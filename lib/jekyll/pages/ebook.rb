module Jekyll
  class EbookPage < Page
    def initialize(site, params)
      @site = site
      @base = site.source
      @dir  = File.join(params["destination"], "ebooks")
      @name = "#{params["name"]}.md"

      self.process(@name)

      self.data = params["book"]
      self.data["name"] = params["name"]
      self.data["layout"] = 'ebook' #temp
    end
  end
end