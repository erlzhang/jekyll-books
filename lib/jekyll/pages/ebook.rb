module Jekyll
  class EbookPage < Page
    def initialize(site, params)
      @site = site
      @base = site.source
      @dir  = params["destination"]
      @name = "#{params["name"]}.md"

      self.process(@name)

      self.data = {}
      self.data["name"] = params["name"]
      self.data["layout"] = params["layout"] #temp
    end
  end
end
