require 'pry'
require 'fileutils'

class FileHandler

  def move(path)
    FileUtils.cd(path)
  end

  def create(directory)
    FileUtils::mkdir_p "#{directory}/output"
    FileUtils::mkdir_p "#{directory}/source/css"
    FileUtils::mkdir_p "#{directory}/source/pages"
    FileUtils::mkdir_p "#{directory}/source/posts"
  end

  def touch(file_name)
    File.new(file_name, "w+")
  end

end
