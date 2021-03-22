require "jekyll/pages/ebook"

module Jekyll
  Jekyll::Hooks.register :pages, :post_write do |page|
    if page.is_a? Jekyll::EbookPage
      input = page.destination("")
      site = page.site
      puts input
      dir = site.in_dest_dir(page.dir)
      output = File.join(dir, "#{page.data["name"]}.mobi")
      puts output
      system "ebook-convert #{input} #{output}"
    end
  end
end