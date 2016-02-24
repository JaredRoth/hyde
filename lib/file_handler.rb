require 'pry'
require 'fileutils'

class FileHandler

  def move(directory)
    FileUtils.cd(directory)
  end

  def touch(file_name)
    File.new(file_name, "w+")
  end

  def create_tree(directory)
    FileUtils::mkdir_p "#{directory}/_output"
    FileUtils::mkdir_p "#{directory}/source/css"
    FileUtils::mkdir_p "#{directory}/source/pages"
    FileUtils::mkdir_p "#{directory}/source/posts"

  end

  def populate_tree(directory)
    # potentially collapse into array
    touch("#{directory}/source/index.markdown")
    touch("#{directory}/source/css/main.css")
    touch("#{directory}/source/pages/about.markdown")
    touch("#{directory}/source/posts/2016-02-20-welcome-to-hyde.markdown")
  end

  def copy_source(directory)
    dir = Dir.pwd
    FileUtils::mkdir_p "#{directory}/_output/css"
    FileUtils::mkdir_p "#{directory}/_output/pages"
    FileUtils::mkdir_p "#{directory}/_output/posts"

    Dir.foreach("#{directory}/source") do |filename|
      next if File.directory?(filename)
      if File.extname(filename) == ".markdown"
        move("#{directory}/_output")
        # # use kramdown
        touch("#{directory}/_output/#{filename}")
        move("#{directory}/source")
      elsif !File.file?(filename)
        move("#{directory}/source/#{filename}")
        Dir.glob("*.{md,markdown}") do |file|
          move("#{directory}/_output/#{filename}")
          # # use kramdown
          touch("#{directory}/_output/#{filename}/#{file}")
          move("#{directory}/source/#{filename}")
        end
        move(dir)
      end
    end
    markdowns
  end
end

if __FILE__ == $0
  fh = FileHandler.new
  fh.create_tree("test-dir")
  fh.populate_tree("test-dir")
  puts fh.copy_source("test-dir")
end
