require 'spec_helper'

pwd = File.join(Dir.pwd, "generator_tests")

describe Jax::Generators::Material::MaterialGenerator do
  def generate(*args)
    Jax::Generators::Material::MaterialGenerator.start(args, :shell => shell)
  end
  
  def shell
    @shell ||= SpecShell.new
  end

  before :each do
    FileUtils.rm_rf pwd
    Dir.chdir File.expand_path('..', pwd)
    FileUtils.mkdir_p pwd
    Dir.chdir pwd
    Jax::Generators::App::AppGenerator.start(["test_app"], :shell => shell)
    Dir.chdir File.join(pwd, "test_app")
  end

  after :each do
    FileUtils.rm_rf pwd
    Dir.chdir File.expand_path('..', pwd)
  end

  context "with material name" do
    before(:each) { generate 'brick' }

    it "should generate model source file" do
      File.should exist("app/resources/materials/brick.yml")
    end
  end
end
