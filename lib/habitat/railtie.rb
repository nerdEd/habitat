require 'habitat'
require 'rails'

module Habitat
  class HabitatRailtie < Rails::Railtie
    initializer "Habitat.configure_heroku_environment_variables" do
      heroku_config = `heroku config --long`
      heroku_config = heroku_config.split("\n").map{|string| string.split("=>").map(&:strip)}
      heroku_config = heroku_config.inject({}){|memo, entry| memo[entry.first] = entry.last;memo;}

      override_path = Rails.root.join('config','habitat.yml')
      override_config = YAML.load_file(override_path) if File.exists?(override_path)

      heroku_config.merge!(override_config)

      heroku_config.each_pair do |key, value|
        ENV[key] = value unless key == "RACK_ENV"
      end
    end
  end
end
