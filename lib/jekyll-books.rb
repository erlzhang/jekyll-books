module Jekyll
  require_relative "util"

  class BookPage < Page
    def initialize(site, base, dir)
      @site = site
      @base = base
      @dir = dir.gsub(/^_/, "").downcase
      @name = "index.md"

      self.process(@name)

      read_yaml(File.join(@base, "_books", @dir), @name)

      self.data["layout"] = 'book'
      
      Util.init_date_of_book(self.data)
    end
  end

  class ChapterPage < Page
    def initialize(site, base, dir, name, book, config)
      @site = site
      @base = base

      if name.include?("/")
        names = File.split(name)
        @dir = File.join(dir, names[0])
        @name = names[1]
      else
        @dir = dir
        @name = name
      end

      self.process(@name)

      read_yaml(File.join(base, "_books", @dir), @name)

      self.data["layout"] = 'chapter'
      self.data["book"] = book
      self.data["title"] = config["title"]
      self.data["level"] = config["level"]
    end

    def is_top_level?
      self.data["level"] == 1
    end
  end

  class BooksGenerator < Generator
    def generate(site)

      books = []

      dir = "_books"
      begin
        Dir.foreach(dir) do |book_dir|
          book_path = File.join(dir, book_dir)
          if File.directory?(book_path) and book_dir.chars.first != "."
            book = BookPage.new(site, site.source, book_dir)

            summary = File.read(File.join(book_path, "SUMMARY.md"))

            parts = get_parts_from_summary(summary)

            chapters = create_chapters(site, parts, book_dir, book)

            add_prev_and_next_to_every_chapter(chapters)

            push_chapters_to_site_pages(site, chapters)

            add_next_to_book_and_prev_to_chapter(book, chapters.first)

            books << book
            site.pages << book
          end
        end

        books += get_books_from_data(site)

        sort_books_by_date(books)

        site.config["books"] = books
      rescue Exception => e
        puts e
      end
    end

    private
      def get_parts_from_summary(summary)
        require "nokogiri"

        html = Kramdown::Document.new(summary).to_html
        parsed_html = Nokogiri::HTML(html)

        chapters = []

        list = parsed_html.xpath("//body/ul/li")
        list.each do |li|
          chapters.push( get_chapter_from_li(li, 1) )

          li.xpath("ul/li").each do |sub_li|
            chapters.push( get_chapter_from_li(sub_li, 2) )
          end
        end
        return chapters
      end

      def get_chapter_from_li(li, level)
        chapter = Hash.new
        chapter["link"] = li.xpath("a/@href").to_s
        chapter["title"] = li.xpath("a/text()").to_s
        chapter["level"] = level
        return chapter
      end

      def add_prev_and_next_to_every_chapter(chapters)
        chapters.each_with_index do |chapter, index|
          if index > 0
            chapter.data["prev"] = chapters[index - 1]
          end
          if index < chapters.size - 1
            chapter.data["next"] = chapters[index + 1]
          end
        end
      end

      def push_chapters_to_site_pages(site, chapters)
        chapters.each do |chapter|
          site.pages << chapter
        end
      end

      def add_next_to_book_and_prev_to_chapter(book, chapter)
        book.data["next"] = chapter
        chapter.data["prev"] = book
      end

      def create_index_page(site, books)
        book_index = IndexPage.new(site, site.source, "", books[0..3])
        book_index.render(site.layouts, site.site_payload)
        book_index.write(site.dest)
        return book_index
      end

      def create_chapters(site, parts, book_dir, book)
        chapters = []
        book.data["parts"] = []

        current = nil

        parts.each do |part|
          chapter = ChapterPage.new(site, site.source, book_dir, part["link"], book, part)

          if chapter.is_top_level?
            book.data["parts"].push(chapter)
            current = chapter
            chapter.data["parts"] = []
          else
            current.data["parts"].push(chapter)
          end

          chapters.push(chapter)
        end
        return chapters
      end

      def sort_books_by_date(books)
        books.sort_by! do |book|
          if book.respond_to? "data"
            [book.data["end"], book.data["start"]]
          else
            [book["end"], book["end"]]
          end
        end
        books.reverse!
      end

      def get_books_from_data(site)
        books = site.data["books"]
        books.each do |book|
          Util.init_date_of_book(book)
        end
      end
  end
end
