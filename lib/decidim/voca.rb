# frozen_string_literal: true

require "yaml"
module Decidim
  module Voca
    def self.each_gem(&block)
      voca_config_file = File.join(ENV.fetch("ROOT"), "voca/voca.yml")
      return unless File.exist? voca_config_file

      gems = YAML.load_file(voca_config_file)["voca"]["gems"]
      return if gems.nil?

      gems.each do |gem_name, gem_options|
        gem_parameters = [gem_name]
        gem_parameters << gem_options.delete("version") unless gem_options["version"].nil?
        gem_parameters << gem_options.delete("version_max") unless gem_options["version_max"].nil?
        block.call(gem_parameters, gem_options)
      end
    end
  end
end
