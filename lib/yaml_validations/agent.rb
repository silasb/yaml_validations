require 'thor'

require_relative 'subcommands/generate'

module YamlValidations
  class Agent < Thor
    include Thor::Actions

    include Subcommands::Generate
  end
end