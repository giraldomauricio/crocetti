require 'parser'
require 'templates'

class CMS

  def section

    "Hello"

  end

  def load(path)
    # Strategy:
    # 1) Load content
    # 2) Extract template name
    # 3) Load template
    # 4) Perform replacements
    content = ''
    parser = Parser.new
    content_object = parser.load_content_file(path)
    if(content_object.template)
      template = Templates.new
      content = template.load_template(content_object.template)
      content_object.contents.each do |tag|
        template_tag = "<cms:content #{tag.name}/>"
        content.gsub!(template_tag,tag.contents)
      end
    end
    content
  end

end
