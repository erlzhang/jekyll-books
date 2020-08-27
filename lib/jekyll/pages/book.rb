require "util"

module Jekyll
  class BookPage < Page
    def initialize(site, base, dir, name)
      @site = site
      @base = base
      @dir  = name
      @name = "index.md"

      self.process(@name)

      read_yaml(File.join(@base, dir, name), @name)

      self.data["layout"] = 'book'
      self.data["parts"] = []
      
      Util.init_date_of_book(self.data)
    end
  end
end
