require_relative 'file_handler'

class Hyde

  def self.process_subcommand(argv)
    method = argv[0]
    path = argv[1]
    args = argv[2..-1].join
    fh = FileHandler.new(path)
    if method == "new"
      if Dir.exist?(path)
        puts "That path already exists! Try again."
        return "Error"
      end
      fh.create_tree
      fh.populate_tree
      "#{path} (new)"
    elsif method == "build"
      fh.copy_source
      "#{path} (build)"
    elsif method == "post"
      fh.post_template(args)
      "#{path}, #{args} (post)"
    elsif method == "watchfs"
      listener = Listen.to(path + '/source') do |modified, added, removed|
        puts "modified file: #{modified}"
        puts "added file: #{added}"
        puts "removed file: #{removed}"
      end
      listener.start
      args.empty? ? sleep : sleep(args.to_i * 60)
      puts "Run 'build' to commit changes or 'watchfs' to continue watching"
      # fh.copy_source
      "#{path}, (watchfs)"
    end
  end

end
