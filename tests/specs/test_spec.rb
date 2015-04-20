ENV['RACK_ENV'] = 'test'

require 'app'  # <-- your sinatra app
require 'rspec'
require 'rack/test'

describe 'The main App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello')
  end

  it "pulls the content" do
    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    ENV['TEMPLATES_FOLDER'] = Dir.pwd + '/tests/specs/contents/templates/'
    get '/load/section1/subsection1/page1'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Title of the document')
    expect(last_response.body).to include('Some HTML 4')
    expect(last_response.body).to include('Some HTML 6')
  end

end