require "jekyll/pages/ebook"

module Jekyll
  Jekyll::Hooks.register :pages, :post_write do |page|
    if page.is_a? Jekyll::EbookPage
      default_setting = {
        "formats" => ["pdf"]
      }

      configs = Jekyll.configuration()
      books_config = configs["books_settings"] || {}
      ebook_config = default_setting.merge(books_config["ebook"] || {})
      if ebook_config["enabled"]
        input = page.destination("")
        site = page.site
        dir = site.in_dest_dir(page.dir)
        ebook_config["formats"].each do |format|
          output = File.join(dir, "#{page.data["name"]}.#{format}")
          system "ebook-convert #{input} #{output} --title=#{page.data['book']['title']} --authors=#{configs['title']} --level1-toc=//h:h1"
        end
      end
    end
  end
end
