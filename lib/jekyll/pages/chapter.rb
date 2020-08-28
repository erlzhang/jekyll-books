module Jekyll
  class ChapterPage < Page
    def initialize(site, params)
      @site = site
      @base = site.source

      path = File.join(params["name"], File.dirname(params["link"]))
      @dir = File.join(params["destination"], path)

      @name = File.basename(params["link"])

      self.process(name)

      read_yaml(
        File.dirname(
          File.join(@base, params["source"], path)
        ),
        name
      )
      
      self.data = params["chapter"].merge(self.data)
      self.data["parts"] = []
    end
  end
end
