require "jekyll-books/book_writer"

module Jekyll
  module Commands
    class Book < Command
      def self.init_with_program(prog)
        prog.command(:book) do |c|
          c.syntax "book [options]"
          c.description 'Create a new book.'
  
          add_options(c)
  
          c.action do |args, options|
            configs = Jekyll.configuration()
            BookWriter.new(
              options["name"],
              File.join(configs["source"], "_books"),
              options
            ).run
          end
        end
      end
  
      def self.add_options(cmd)
        cmd.option "name", "-n", "--name NAME"
        cmd.option "title", "-t", "--title TITLE"
        cmd.option "forced", "-f", "--forced"
      end
    end
  end
end
