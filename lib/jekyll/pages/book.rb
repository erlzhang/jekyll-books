require "util"

module Jekyll
  class BookPage < Page
    def initialize(site, params)
      @site = site
      @base = site.source
      @dir  = File.join(params["destination"], params["name"])
      @name = "index.md"

      self.process(@name)

      read_yaml(
        File.join(@base, params["source"], params["name"]),
        @name
      )

      self.data = params["book"].merge(self.data)
      self.data["parts"] = []

      Util.init_date_of_book(self.data)
    end
  end
end
