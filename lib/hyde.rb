require_relative 'builder'

class Hyde
  attr_reader :method, :path, :args, :hyde

  def initialize(argv)
    @method = argv[0].downcase
    @path = test_path(argv[1])
    @args = argv[2..-1].join(" ")
    @hyde = Builder.new(path)
  end

  def process_subcommand
    case method
    when "new"
      new_command
    when "build"
      hyde.copy_source
      "#{path} (build)"
    when "post"
      hyde.create_post(args)
      "#{path}, #{args} (post)"
    when "watchfs"
      watcher
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
    hyde.create_tree
    hyde.populate_tree
    "#{path} (new)"
  end

  def watcher
    listener = Listen.to(path + '/source') do |modified, added, removed|
      puts "modified file: #{modified}" unless modified.empty?
      puts "added file: #{added}"       unless added.empty?
      puts "removed file: #{removed}"   unless removed.empty?
    end
    listener.start
    args.empty? ? sleep : sleep(args.to_i * 60)
    puts "Run 'build' to commit changes or 'watchfs' to continue watching"
    # hyde.copy_source
  end

  def test_path(given_path)
    given_path[0] == '/' ? given_path[1..-1] : given_path
  end

end
