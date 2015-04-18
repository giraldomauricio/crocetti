class Parser

  attr_accessor :location

  def set_location(path)
    if(Dir.exists?path)
      @location = path
    end
  end

  def initialize
    @location = nil
    set_location(ENV['CONTENTS_FOLDER'])
  end

  def extract(tag)
    result = []
    tags =  tag.scan(/<cms:content(.*)\/>/)
    tags.each { |tag| result << tag[0].strip }
    result
  end

  def load_content_file(version = "default")
    "something"
  end

  def load_sections
    directory_hash(@location)
  end

  def get_version(path)
    if(path[-1,1] != '/')
      path += '/'
    end
    version = nil
    version_file_location = @location + path + 'version'
    if(File.exists? version_file_location)
      version = File.open(version_file_location,'rb').read
    end
    version
  end

  def get_contents(path)
    contents = nil
    if(path[-1,1] != '/')
      path += '/'
    end
    version = get_version(path)
    contents_file = @location + path + 'version' + version + '.xml'
    if(File.exists?(contents_file))
      contents = File.open(contents_file,'rb').read
    end
    contents
  end

  def directory_hash(path, name=nil)
    data = {:data => (name || path)}
    data[:children] = children = []
    Dir.foreach(path) do |entry|
      next if (entry == '..' || entry == '.')
      full_path = File.join(path, entry)
      if File.directory?(full_path)
        children << directory_hash(full_path, entry)
      else
        #children << entry
      end
    end
    return data
  end

end