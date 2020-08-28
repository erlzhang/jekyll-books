require "jekyll/pages/chapter"
require "jekyll/pages/book"
require_relative "summary"

class BookReader
  attr_reader :root, :site, :name, :destination, :params
  attr_accessor :index, :pages

  def initialize(params, site, name)
    @root        = params["source"]
    @destination = params["destination"]
    @params      = params
    @site        = site
    @name        = name
    @index       = 0
    @pages       = []
  end

  def read
    @pages = [book_page]
    index = 0

    recursive_read_chapters(summary.read, 1, book_page)
    add_prev_and_next

    pages
  end

  def recursive_read_chapters(chapters, level, parent)
    page = parent
    chapter = parent

    begin
      chapter = chapters[index]
      return unless chapter

      if chapter["level"] > level
        recursive_read_chapters(chapters, chapter["level"], page)
      else
        page = read_chapter(chapter)
        pages << page
        parent.data["parts"] << page
      end

      @index += 1
    end while chapter["level"] >= level
  end

  def add_prev_and_next
    pages.each_with_index do |page, i|
      if i > 0
        page.data["prev"] = pages[i - 1]
      end
      if i < pages.size - 1
        page.data["next"] = pages[i + 1]
      end
    end
  end

  def read_chapter(chapter)
    page = Jekyll::ChapterPage.new(
      site,
      params.merge({"name" => name}).merge(chapter)
    )
    page.data["book"] = book_page
    page
  end

  def summary
    Summary.new(book_folder)
  end

  def book_folder
    File.join(site.source, root, name)
  end

  def book_page
    @book_page ||= Jekyll::BookPage.new(
      site,
      params.merge({
        "name" => name
      })
    )
  end
end