require "jekyll-books/books_parser"
require "util"

module Jekyll
  class BooksGenerator < Generator
    def generate(site)
      params = get_params(site)

      parser = BooksParser.new(params["source"], site)
      parser.parse(params)
      site.pages += parser.pages

      books = parser.books
      books += get_books_from_data(site)
      sort_books_by_date(books)
      site.config["books"] = books
    end

    def get_params(site)
      default_setting = {
        "source" => "_books",
        "destination" => "/",
        "book" => {
          "layout" => "book"
        },
        "chapter" => {
          "layout" => "chapter"
        }
      }

      default_setting.merge(site.config["books_settings"] || {})
    end

    private
      def get_books_from_data(site)
        books = site.data["books"]
        return [] unless books

        books.each do |book|
          Util.init_date_of_book(book)
        end
      end

      def sort_books_by_date(books)
        books.sort_by! do |book|
          if book.respond_to? "data"
            [book.data["end"], book.data["start"]]
          else
            [book["end"], book["start"]]
          end
        end
        books.reverse!
      end
  end
end
