require 'fileutils'
require 'kramdown'
require 'erb'
require 'listen'
require 'pry'

class FileHandler
  attr_reader :directory

  def initialize(directory)
    @directory = directory
  end

  def move(directory)
    FileUtils.cd(directory)
  end

  def inject(html)
    ERB.new(File.read("#{directory}/source/layouts/default.html.erb")).result(binding)
  end
end

# :nocov:
if __FILE__ == $0
  dir = "test-dir"
  fh = FileHandler.new(dir)
  puts fh.directory + '/source'
  fh.create_tree
  fh.populate_tree
  fh.create_post("My Post")
  fh.copy_source
  FileUtils.remove_dir('test-dir', force = true)
end
# :nocov:
