get '/' do
  cms_instance = CMS.new
  cms_instance.section
end
