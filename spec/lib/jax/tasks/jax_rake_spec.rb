require 'spec_helper'

pwd = File.join(Dir.pwd, "generator_tests")

describe "Rake Tasks:" do
  def shell
    @shell ||= SpecShell.new
  end
  
  def rake(args)
    output = `bundle exec rake #{args} 2>&1`
    if !$?.success?
      raise output
    end
  end

  before :all do
    FileUtils.rm_rf pwd
    Dir.chdir File.expand_path('..', pwd)
    FileUtils.mkdir_p pwd
    Dir.chdir pwd
    Jax::Generators::App::AppGenerator.start(["test_app"], :shell => shell)
    Dir.chdir File.join(pwd, "test_app")
    File.open("Gemfile", "w") { |f| f.print "gem 'jax', :path => '#{File.join(File.dirname(__FILE__), "../../../..")}'"}
    `bundle install`
    Jax::Generators::Controller::ControllerGenerator.start(['welcome', 'index'], :shell => shell)
  end

  after :all do
    FileUtils.rm_rf pwd
    Dir.chdir File.expand_path('..', pwd)
  end
  
  context "package" do
    before(:each) { rake('jax:package') }
    
    context "javascript" do
      subject { File.read(File.expand_path('pkg/test_app.js')) }
      
      it "should contain views" do
        subject.should =~ /Jax.views.push\('welcome\/index'/
      end
      
      it "should contain welcome controller" do
        subject.should =~ /var WelcomeController = /
      end
      
      it "should contain application controller" do
        subject.should =~ /var ApplicationController = /
      end
      
      it "should contain welcome helper" do
        subject.should =~ /var WelcomeHelper = /
      end
      
      it "should contain application helper" do
        subject.should =~ /var ApplicationHelper = /
      end
    end
  end
end