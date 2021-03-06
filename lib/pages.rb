require 'parser'
require 'fileutils'
require 'logger'

class Page

  attr_accessor :path, :current, :versions, :content, :template

  def initialize (path,template=nil)
    @log = Logger.new(STDOUT)
    @log.info("Page - Initialize")
    @path = path
    parser = Parser.new
    @current = parser.get_version(path)
    @versions = []
    @template = template if (!get_template)
    get_versions
  end

  def get_template
    result = false
    if (@current && @current != "0")
      current_content_file = ENV['CONTENTS_FOLDER'] + @path + '/version' + @current + '.xml'
      if(File.exists?(current_content_file))
        @content = File.open(current_content_file,'rb').read
        parser = Parser.new
        content_obj = parser.pull_page_information(@path,@content)
        @template = content_obj.template
        result = true
      end
    end
    result
  end

  def get_containing_folder
    path_array = @path.split('/')
    path_array[0..-2].join('/')
  end

  def clone_page(path, new_name="clone")
    if(!Dir.exists?(get_folder_path(new_name)))
      FileUtils.mkdir(get_folder_path(new_name))
      FileUtils.cp_r(ENV['CONTENTS_FOLDER'] + path + '/.' ,get_folder_path(new_name))
    end
  end

  def save_page
    new_version = @current.to_i
    new_version += 1
    @current = new_version.to_s
    new_file = ENV['CONTENTS_FOLDER'] + @path + '/version' + @current + '.xml'
    @log.info("Page - Save File:#{new_file}")
    File.open(new_file, 'w') { |file| file.write(@content) }
    get_versions
  end

  def get_folder_path(path=nil)
    path = @path if !path
    ENV['CONTENTS_FOLDER'] + get_containing_folder + '/' + path
  end

  def get_real_path
    ENV['CONTENTS_FOLDER'] + @path
  end

  def get_versions
    @versions = []
    if(Dir.exists?(get_real_path))
      Dir.foreach(get_real_path) do |entry|
        next if (entry == '..' || entry == '.')
        if (File.file?(get_real_path + '/' + entry) && entry.include?('.xml') && entry.include?('version'))
          @versions << entry.gsub('version','').gsub('.xml','')
        else
        end
      end
    end
  end

end