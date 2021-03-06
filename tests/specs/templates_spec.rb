require File.expand_path '../spec_helper.rb', __FILE__

describe 'Templates Location' do

  it "then returns a list" do
    templates = Templates.new
    templates.set_location(Dir.pwd + '/tests/specs/contents/templates/')
    expect(templates.get_list.is_a?Array).to eq true
    expect(templates.get_list.size).to eq 2
  end

  it 'then sets and gets the location' do
    templates = Templates.new
    templates.set_location(Dir.pwd + '/tests/specs/contents/templates/')
    expect(templates.location).to eq Dir.pwd + '/tests/specs/contents/templates/'
  end

  it "then set the location" do
    templates = Templates.new
    templates.set_location ("contents")
    expect(templates.location).to eq "contents"
  end

  it "then there is no location" do
    ENV['TEMPLATES_FOLDER'] = 'foo'
    templates = Templates.new
    expect(templates.location).to be_nil
  end

  it "then get the configuration one" do
    ENV['TEMPLATES_FOLDER'] = Dir.pwd + '/tests/specs/contents/templates/'
    templates = Templates.new
    expect(templates.location).to eq(ENV['TEMPLATES_FOLDER'])
  end

end

describe 'Templates Loading' do

  it 'does not load an wrong template by name' do
    templates = Templates.new
    templates.set_location(Dir.pwd + '/tests/specs/contents/templates/')
    expect(templates.template_exists?('foo.html')).to eq(false)
    template_file = templates.load_template('foo.html')
    expect(template_file).to be_nil
  end

  it 'loads a template by name' do
    templates = Templates.new
    templates.set_location(Dir.pwd + '/tests/specs/contents/templates/')
    template_file = templates.load_template('template1.html')
    expect(template_file).not_to be_nil
    expect(template_file).to include('<cms:content header/>')
  end

end