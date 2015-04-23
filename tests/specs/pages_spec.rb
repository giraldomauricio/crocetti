require File.expand_path '../spec_helper.rb', __FILE__

describe 'Pages Operation' do

  it "creates a page object of an existing page" do

    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    page = Page.new('section1/subsection1/page1')
    expect(page.current).to eq('2')
    expect(page.path).to eq('section1/subsection1/page1')
    expect(page.versions).to eq(["1","2"])
    expect(page.content.inspect).to include('Some HTML 4')
    expect(page.content.inspect).to include('Some HTML 6')
    expect(page.template).to eq('template1.html')
  end

  it "creates a page object of a non existing page" do

    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    page = Page.new('section1/subsection1/foo')
    expect(page.current).to eq("0")
    expect(page.path).to eq('section1/subsection1/foo')
    expect(page.versions).to eq([])
    expect(page.template).to be_nil
  end

  it 'gets the parent folder' do

    page = Page.new('/foo/bar/doh')
    expect(page.get_containing_folder).to eq('/foo/bar')

  end

  it 'gets the real path' do
    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    page = Page.new('foo/bar/doh')
    expect(page.get_real_path).to eq(ENV['CONTENTS_FOLDER'] + 'foo/bar/doh')

  end

  it "clones a page" do

    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    page = Page.new('section1/subsection1/page1')

    page.clone_page('section1/subsection1/page1','new_page')

    page = Page.new('section1/subsection1/new_page')

    expect(page.current).to eq('2')
    expect(page.path).to eq('section1/subsection1/new_page')
    expect(page.versions).to eq(["1","2"])

    expect(page.template).to eq('template1.html')

    FileUtils.rm_rf(Dir.pwd + '/tests/specs/contents/site/section1/subsection1/new_page')

  end

  it 'returns the page path' do
    ENV['CONTENTS_FOLDER'] = '/foo/bar'
    page = Page.new('/section/page/')
    expect(page.get_folder_path('blah')).to eq('/foo/bar/section/blah')
    expect(page.template).to be_nil
  end

  it 'creates a new version' do

    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    FileUtils.cp(Dir.pwd + '/tests/specs/contents/site/section1/subsection1/page1/version',Dir.pwd + '/tests/specs/contents/site/section1/subsection1/page1/version.bk')
    page = Page.new('section1/subsection1/page1')
    page.save_page
    expect(page.current).to eq('3')
    expect(page.versions).to eq(["1","2","3"])
    expect(page.template).to eq('template1.html')
    FileUtils.cp(Dir.pwd + '/tests/specs/contents/site/section1/subsection1/page1/version.bk',Dir.pwd + '/tests/specs/contents/site/section1/subsection1/page1/version')
    File.delete(Dir.pwd + '/tests/specs/contents/site/section1/subsection1/page1/version3.xml')
    File.delete(Dir.pwd + '/tests/specs/contents/site/section1/subsection1/page1/version.bk')

  end

  it 'creates a new page from scratch' do
    ENV['CONTENTS_FOLDER'] = Dir.pwd + '/tests/specs/contents/site/'
    page = Page.new('section1/subsection1/foo','template1.html')
    expect(page.current).to eq('0')
    expect(page.path).to eq('section1/subsection1/foo')
    expect(page.versions).to eq([])
    expect(page.template).to eq('template1.html')
  end

end