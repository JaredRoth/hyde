require_relative 'file_handler'

class Hyde

  def self.process_subcommand(method, path)
    fh = FileHandler.new

    return "That path already exists! Try again." if File.exist?(path)

    if method == "new"
      fh.create_tree(path)
      fh.populate_tree(path)
    elsif method == "build"
      fh.
      fh.
    end
  end

end
