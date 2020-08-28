require_relative "book_reader"

class BooksParser
  attr_reader :root, :site, :books, :pages

  def initialize(root, site)
    @root = root
    @site = site
    @books = []
    @pages = []
  end

  def root_path
    File.join(site.source, root)
  end

  def parse(params)
    Dir.foreach(root_path) do |book_dir|
      book_path = File.join(root_path, book_dir)
      if File.directory?(book_path) and book_dir.chars.first != "."
        pages = BookReader.new(params, site, book_dir).read
        books << pages[0]
        @pages += pages
      end
    end
  end
end