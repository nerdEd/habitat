require 'habitat'
require 'rails'

module Habitat
  class HabitatRailtie < Rails::Railtie
    initializer "Habitat.configure_heroku_environment_variables" do
      heroku_config = `heroku config`
      heroku_config = heroku_config.split("\n").map{|string| string.split("=>").map(&:strip)}
      heroku_config.each do |conf|
        ENV[conf.first] = conf.last
      end
    end
  end
end