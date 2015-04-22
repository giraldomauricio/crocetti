require "rexml/document"
require File.expand_path('../../models/contents', __FILE__)
require File.expand_path('../../models/content', __FILE__)
require 'logger'

class Parser

  include REXML

  attr_accessor :location, :log

  def set_location(path)
    if(Dir.exists?path)
      @location = path
    end
  end

  def initialize
    @log = Logger.new(STDOUT)
    @log.info("Parser - Initialize")
    @location = nil
    set_location(ENV['CONTENTS_FOLDER'])
  end

  def extract(tag)
    @log.info("Parser - Extract")
    result = []
    tags =  tag.scan(/<cms:content(.*)\/>/)
    tags.each { |tag| result << tag[0].strip }
    result
  end

  def load_content_file(file, version = "default")
    @log.info("Parser - Load Content File:#{file} - Version: #{version} ")
    content_obj = Content.new
    contents = get_contents(file)
    if(contents)
      xml = Document.new contents
      content_obj.name = file
      content_obj.version = xml.elements["contents"].attributes["version"]
      content_obj.date = xml.elements["contents"].attributes["date"]
      content_obj.template = xml.elements["contents"].attributes["template"]
      content_obj.contents = pull_content_tags(xml)
    end
    content_obj
  end

  def pull_content_tags(xml)
    contents_array = []
    xml.elements.each("contents/tag") do |tag|
      node = Content.new
      node.name = tag.attributes["name"]
      node.contents = tag[1].to_s
      contents_array << node
    end
    contents_array
  end

  def load_sections
    directory_hash(@location)
  end

  def get_version(path)
    if(path[-1,1] != '/')
      path += '/'
    end
    version = nil
    if(@location)
      version_file_location = @location + path + 'version'
      if(File.exists? version_file_location)
        version = File.open(version_file_location,'rb').read
      end
    end
    version
  end

  def get_contents(path)
    contents = nil
    if(path[-1,1] != '/')
      path += '/'
    end
    version = get_version(path)
    if (version)
      contents_file = @location + path + 'version' + version + '.xml'
      if(File.exists?(contents_file))
        contents = File.open(contents_file,'rb').read
      end
    end
    contents
  end

  def directory_hash(path, name=nil)
    data = {:data => (name || path)}
    data[:children] = children = []
    Dir.foreach(path) do |entry|
      next if (entry == '..' || entry == '.')
      full_path = File.join(path, entry)
      if (File.directory?(full_path))
        children << directory_hash(full_path, entry)
      else
        #children << entry
      end
    end
    return data
  end

end