require_relative "summary"
require "util"

class BookWriter
  attr_reader :name, :root, :params, :summary
  def initialize(name, root, params)
    @name   = name
    @root   = root
    @params = params
    @summary = Summary.new(book_folder)
  end

  def run
    mkdir
    create_index
    create_summary
  end

  def book_folder
    File.join(root, name)
  end

  def summary_file
    summary.file_path
  end

  def index_file
    summary.index_path
  end

  def mkdir
    unless File.directory?(book_folder)
      FileUtils.mkdir_p(book_folder)
    end
  end

  def create_index
    return if File.file?(index_file)

    f = File.new(index_file, "w+")
    f.write(content)
  end

  def create_summary
    return if File.file?(summary_file) && !params["forced"]

    summary.write(true)
  end

  def content
    front_matter = YAML.dump(
      Util.cover_default({
        "title"  => name.capitalize,
        "start"  => default_year,
        "end"    => default_year,
        "img"    => img_url
      }, params)
    )

    front_matter + "---\n"
  end

  def default_year
    Date.today.year
  end

  def img_url
    "/img/home/#{name}.jpg"
  end
end