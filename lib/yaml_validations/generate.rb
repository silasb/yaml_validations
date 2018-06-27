require 'yaml'

module YamlValidations
  class Generate
    def self.generate(yaml_file)

      yaml = YAML.load_file(yaml_file)

      $schemas = {}

      yaml.each do |klass, values|
        parse_fields([klass], values)
      end

      q = $schemas.each_with_index do |(klass, validations), i|
        schema = ''
        schema << "#{klass.map(&:capitalize).join("::")}Schema = Dry::Validation.Schema do\n"

        ['required', 'optional'].each do |section_name|
          section = validations[section_name]
          section.each do |m|
            schema << "  " << m << "\n"
          end
        end

        schema << "end\n\n"

        if i == $schemas.size - 1
          puts schema.chomp
        else
          puts schema
        end
      end
    end

    def self.parse_fields(klasses, values)
      ['required', 'optional'].each do |s|

        section = values[s]
        section_name = s

        next if section.nil?

        section.each do |field, validations|
          if validations.is_a?(Hash) and (validations.keys.sort & ['required', 'optional'].sort).size > 0
            klass = field
            values = validations

            #p klass, values
            parse_fields(klasses.dup.push(klass), values)
          else
            #p klasses
            #p field, validations
            $schemas[klasses] ||= {
              'required' => [],
              'optional' => []
            }

            if validations.is_a?(Hash) and validations.has_key?('schema')
              root_klass = klasses.dup
              root_klass.pop

              schema_type = validations['schema']

              if schema_type.is_a? Array
                schema_type = schema_type.first
                root_klass.push schema_type
                schema_klass = root_klass.map(&:capitalize).join("::")

                $schemas[klasses][section_name] << "required(:#{field}).each { schema(#{schema_klass}Schema) }"
              elsif schema_type.is_a? String
                root_klass.push schema_type
                schema_klass = root_klass.map(&:capitalize).join("::")
                $schemas[klasses][section_name] << "required(:#{field}).schema(#{schema_klass}Schema)"
              end

            else
              $schemas[klasses][section_name] << generate_filled(section_name, field, validations)
            end
          end
        end
      end
    end

    def self.generate_filled(section_name, field, validation)

      if validation.is_a? Hash
        methods = validation.map do |rule, predicate|
          ["#{rule}(:#{predicate})"]
        end

        "#{section_name}(:#{field}).#{methods.join('.')}"
      else
        method = section_name == 'required' ? 'filled' : 'maybe'
        if validation.nil?
          "#{section_name}(:#{field}).#{method}"
        else
          "#{section_name}(:#{field}).#{method}(:#{validation})"
        end
      end
    end
  end
end