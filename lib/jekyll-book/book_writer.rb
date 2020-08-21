class BookWriter
  attr_reader :name, :root, :params
  def initialize(name, root, params)
    @name   = name
    @root   = root
    @params = params
  end

  def book_folder
    File.join(root, name)
  end

  def summary_file
    File.join(book_folder, "SUMMARY.md")
  end

  def index_file
    File.join(book_folder, "index.md")
  end

  def mkdir
    unless File.directory?(book_folder)
      FileUtils.mkdir_p(book_folder)
    end
  end

  def create_index
  end

  def create_summary
  end

  def summary
    "# Summary\n\n"
  end

  def content
    front_matter = YAML.dump({
      "title"  => name.capitalize,
      "start"  => year,
      "end"    => year,
      "img"    => img_url
    }.merge(params))

    front_matter + "---\n"
  end

  def year
    Date.today.year
  end

  def img_url
    "/img/home/#{name}.jpg"
  end
end