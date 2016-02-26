require_relative 'file_handler'

class Builder
  attr_reader :directory

  def initialize(directory)
    @directory = directory
  end

  def create_post(title)
    t = Time.new
    filename = "#{directory}/source/posts/#{t.strftime("%F")}" +
    "-#{title.downcase.gsub(" ", "-")}.markdown"
    File.write(filename, "# #{title}\n\nyour content here")
  end

  def create_tree
    FileUtils::mkdir_p "#{directory}/_output"
    FileUtils::mkdir_p "#{directory}/source/css"
    FileUtils::mkdir_p "#{directory}/source/pages"
    FileUtils::mkdir_p "#{directory}/source/posts"
    FileUtils::mkdir_p "#{directory}/source/layouts"
  end

  def populate_tree
    source_files = [
      ['test2.css', 'css/test2.css'],
      ['about.markdown', 'index.markdown'],
      ['index.markdown', 'pages/about.markdown'],
      ['default.html.erb', 'layouts/default.html.erb'],
      ['welcome-to-hyde.markdown',
        "posts/#{Time.new.strftime("%F")}-welcome-to-hyde.markdown"]
      ]
    source_files.each do |subarray|
      File.write("#{directory}/source/"+subarray[1],
             File.read('lib/templates/'+subarray[0]))
    end
  end

  def copy_source
    FileUtils.copy_entry("#{directory}/source", "#{directory}/_output")

    parse_to_html
  end

  def parse_to_html
    Dir.glob("#{directory}/_output/**/*.{md,markdown}") do |file|
      new_file_ext = file.sub(/(.md|.markdown)/, ".html")
      markdown     = File.read(file)
      html         = Kramdown::Document.new(markdown).to_html
      formatted    = FileHandler.new(directory).inject(html)

      File.write(new_file_ext, formatted)
      File.delete(file)
    end
  end
end
