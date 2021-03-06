# This script is required by script/jax if script/jax is found.

require 'thor'
require 'thor/group'
require File.expand_path('../../jax', File.dirname(__FILE__))

module Jax
  module Generators
    class Command < Thor::Group
      class << self
        def inherited(base)
          base.base_path = File.dirname(caller.first.gsub(/:.*$/, ''))
        end
        
        def base_path
          @base_path || raise("Jax Command base path was not found")
        end
        
        def base_path=(path)
          @base_path = path
        end

        def usage
          usage = ERB.new(File.read(File.expand_path("USAGE", base_path)), nil, '-')
          usage.result(binding)
        end
        
        def start(given_args=ARGV, config={})
          if (given_args.length == 0)
            puts usage
          else
            super
          end
        end
      end
    end
    
    autoload :Controller, File.join(File.dirname(__FILE__), "controller/controller_generator")
    autoload :Model,      File.join(File.dirname(__FILE__), "model/model_generator")
    autoload :LightSource,File.join(File.dirname(__FILE__), "light_source/light_source_generator")
    autoload :Material,   File.join(File.dirname(__FILE__), "material/material_generator")
    autoload :Shader,     File.join(File.dirname(__FILE__), "shader/shader_generator")
  end
end

class JaxGeneratorInvoker < Thor
  def self.basename
    "jax generate"
  end

  desc "controller", "generates a new controller"
  def controller(*args)
    Jax::Generators::Controller::ControllerGenerator.start(args)
  end
  
  desc "model", "generates a new model"
  def model(*args)
    Jax::Generators::Model::ModelGenerator.start(args)
  end
  
  desc "light", "generates a new light source"
  def light(*args)
    Jax::Generators::LightSource::LightSourceGenerator.start(args)
  end
  
  desc "material", "generates a new material"
  def material(*args)
    args = ARGV.dup
    2.times { args.shift }
    Jax::Generators::Material::MaterialGenerator.start(args)
  end

  desc "scaffold", "generates a controller, model and material, all with the same name"
  def scaffold(*name)
    name = name.shift || []
    Jax::Generators::Controller::ControllerGenerator.start([name, 'index'])
    Jax::Generators::Model::ModelGenerator.start([name])
    Jax::Generators::Material::MaterialGenerator.start([name])
  end

  desc "shader", "generates a new custom shader"
  def shader(*name)
    Jax::Generators::Shader::ShaderGenerator.start(name)
  end
end

class JaxGenerator < Thor
  desc "generate", "generates a controller, model, light source, material or shader"
  def generate(*args)
    JaxGeneratorInvoker.start(args)
  rescue ArgumentError
    puts $!.message
  end
end
