require 'active_support/core_ext'

module Jax
  module Generators
    module Material
      class MaterialGenerator < Jax::Generators::Command
        include Thor::Actions
        argument :name, :desc => "The name of this material", :banner => "[name]"
        class_option :append, :default => false, :type => :boolean
        
        def initialize(args = [], *other)
          chain.unshift args.pop while args.length > 1 # name is arg0
          super(args, *other)
        end
        
        def self.source_root
          File.expand_path("templates", File.dirname(__FILE__))
        end
             
        def material
          filename = File.join("app/resources/materials", "#{file_name}.yml")
          
          if options[:append]
            tmp = "tmp/amendment.#{file_name}.yml"
            template 'append.yml.tt', tmp, :verbose => false
            
            if File.file?(filename)
              say_status :append, filename, :green
            else
              say_status :missing, filename, :red
              return
            end
            
            File.open(filename, "a+") { |f| f.puts File.read(tmp) }
            
            # doesn't append if the end of the file matches string identically - usually useful, but in this case troublesome.
            # append_to_file File.join("app/resources/materials", "#{file_name}.yml"), File.read("tmp/amendment.#{file_name}.yml")
            
            remove_file tmp, :verbose => false
          else
            template 'material.yml.tt', filename
          end
        end
        
        protected
        def chain
          @chain ||= []
        end
        
        class << self
          def supported_shaders
            Jax.application.shaders.select do |shader|
              shader.manifest && !shader.manifest.empty?
            end
          end
        end
        
        def shader(name)
          name = name.strip
          Jax.application.shaders.find(name) || raise(ArgumentError, "Shader not found: '"+name+"'")
        end
        
        def banner
          "jax generate material #{self.arguments.map { |a| a.usage }.join(' ')}"
        end

        def file_name
          name.underscore
        end
        
        def class_name
          name.camelize
        end
        
        def plural_name
          name.pluralize
        end
      end
    end
  end
end
