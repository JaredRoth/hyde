require_relative 'file_handler'

class Hyde

  def self.process_subcommand(argv)
    fh = FileHandler.new
    method = argv[0]
    path = argv[1]
    title = argv[2..-1].join
    if method == "new"
      return "That path already exists! Try again." if File.exist?(path)
      fh.create_tree(path)
      fh.populate_tree(path)
      "#{path} (new)"
    elsif method == "build"
      fh.copy_source(path)
      "#{path} (build)"
    elsif method == "post"
      fh.post_template(path, title)
      "#{path}, #{title} (post)"
    end
  end

end
