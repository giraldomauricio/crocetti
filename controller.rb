get '/' do
  cms_instance = CMS.new
  cms_instance.section
end

get '/load/*' do
  cms = CMS.new
  parameters = params['splat']
  cms.load(parameters[0])
end
