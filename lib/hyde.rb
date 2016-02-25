require_relative 'file_handler'

class Hyde
  attr_reader :method, :path, :args, :fh

  def initialize(argv)
    @method = argv[0].downcase
    @path = test_path(argv[1])
    @args = argv[2..-1].join
    @fh = FileHandler.new(path)
  end

  def process_subcommand
    case method
    when "new"
      new_command
    when "build"
      fh.copy_source
      "#{path} (build)"
    when "post"
      fh.post_template(args)
      "#{path}, #{args} (post)"
    when "watchfs"
      monitor
      "#{path}, (watchfs)"
    else
      puts "That is not a valid command"
      "Error"
    end
  end

  def new_command
    if Dir.exist?(path)
      puts "That path already exists! Try again."
      return "Error"
    end
    fh.create_tree
    fh.populate_tree
    "#{path} (new)"
  end

  def monitor
    listener = Listen.to(path + '/source') do |modified, added, removed|
      puts "modified file: #{modified}"
      puts "added file: #{added}"
      puts "removed file: #{removed}"
    end
    listener.start
    args.empty? ? sleep : sleep(args.to_i * 60)
    puts "Run 'build' to commit changes or 'watchfs' to continue watching"
    # fh.copy_source
  end

  def test_path(given_path)
    given_path[0] == '/' ? given_path[1..-1] : given_path
  end

end
