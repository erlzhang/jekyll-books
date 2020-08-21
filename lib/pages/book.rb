require "util"

module Jekyll
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
end
