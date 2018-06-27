require_relative '../generate'

module YamlValidations
  module Subcommands
    module Generate

      TYPES = %w[dry-validation].freeze

      def self.included(thor)
        thor.class_eval do

          desc 'generate TYPE YAML_FILE', 'generate a specific validation file from yaml file'
          define_method 'generate' do |type, yaml_file|
            unless TYPES.include?(type)
              puts "Type #{type} not in #{TYPES}."
              return
            end

            YamlValidations::Generate.generate(yaml_file)
          end
        end
      end
    end
  end
end