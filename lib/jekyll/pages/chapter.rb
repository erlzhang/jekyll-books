module Jekyll
  class ChapterPage < Page
    def initialize(site, base, path, target)
      @site = site
      @base = base
      @dir = File.dirname(target)
      @name = File.basename(path)

      self.process(name)

      read_yaml(File.dirname(File.join(base, path)), name)

      self.data["layout"] = 'chapter'
      self.data["parts"] = []
    end
  end
end
