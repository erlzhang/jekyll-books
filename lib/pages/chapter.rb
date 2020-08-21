module Jekyll
  class ChapterPage < Page
    def initialize(site, base, dir, name, book, config)
      @site = site
      @base = base

      if name.include?("/")
        names = File.split(name)
        @dir = File.join(dir, names[0])
        @name = names[1]
      else
        @dir = dir
        @name = name
      end

      self.process(@name)

      read_yaml(File.join(base, "_books", @dir), @name)

      self.data["layout"] = 'chapter'
      self.data["book"] = book
      self.data["title"] = config["title"]
      self.data["level"] = config["level"]
    end

    def is_top_level?
      self.data["level"] == 1
    end
  end
end
