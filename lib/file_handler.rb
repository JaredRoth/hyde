require 'pry'
require 'fileutils'

class FileHandler

  def move(directory)
    directory[0] = Dir.home if directory[0] == '~'
    FileUtils.cd(directory)
  end

  def create(directory)
    directory[0] = Dir.home if directory[0] == '~'

    FileUtils::mkdir_p "#{directory}/output"
    FileUtils::mkdir_p "#{directory}/source/css"
    FileUtils::mkdir_p "#{directory}/source/pages"
    FileUtils::mkdir_p "#{directory}/source/posts"
  end

  def touch(file_name)
    File.new(file_name, "w+")
  end

end
