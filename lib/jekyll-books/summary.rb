require "find"
require "nokogiri"
require "kramdown"

class Summary
  attr_reader :folder

  def initialize(folder)
    @folder = folder
  end

  def file_path
    File.join(folder, "SUMMARY.md")
  end

  def index_path
    File.join(folder, "index.md")
  end

  def chapter_files
    files = []
    Find.find(folder) do |f|
      if File.file?(f) and
         ![file_path, index_path].include?(f)
        files << f if File.file?(f)
      end
    end
    files.sort! do |f1, f2|
      File.ctime(f1) <=> File.ctime(f2) 
    end
  end

  def chapters
    chapter_files.map do |f|
      {
        :title => get_title(f),
        :path => get_relative_path(f)
      }
    end
  end

  def get_title(file)
    content = File.read(file)
    html = Kramdown::Document.new(content).to_html
    parsed_html = Nokogiri::HTML(html)
    parsed_html.xpath("//h1/text()").to_s
  end

  def get_relative_path(file)
    file.sub(folder + "/", "")
  end

  def write(autoload = false)
    File.open(file_path, "w+") do |f|
      f.write summary_title
      if autoload
        chapters.each do |chapter|
          f.write "* [#{chapter[:title]}](#{chapter[:path]})\n"
        end
      end
    end
  end

  def read
    content = File.read(file_path)
    html = Kramdown::Document.new(content).to_html
    parsed_html = Nokogiri::HTML(html)

    chapters = []
    parsed_html.xpath("//body/ul/li").each do |li|
      recursive_parse_chapter(li, 1, chapters)
    end
    chapters
  end

  def recursive_parse_chapter(content, level, result)
    result << parse_chapter(content, level)

    content.xpath("ul/li").each do |li|
      recursive_parse_chapter(li, level + 1, result)
    end
  end

  def parse_chapter(chapter, level)
    {
      "link" => chapter.xpath("a/@href").to_s,
      "title" => chapter.xpath("a/text()").to_s,
      "level" => level
    }
  end

  def summary_title
    "# Summary\n\n"
  end
end