require_relative 'file_handler'

class Hyde

  def self.process_subcommand(argv)
    method = argv[0]
    path = argv[1]
    title = argv[2..-1].join
    fh = FileHandler.new(path)
    if method == "new"
      return "That path already exists! Try again." if File.exist?(path)
      fh.create_tree
      fh.populate_tree
    elsif method == "build"
      fh.copy_source
      "#{path} (build)"
    elsif method == "post"
      fh.post_template(title)
      "#{path}, #{title} (post)"
    end
  end

end
