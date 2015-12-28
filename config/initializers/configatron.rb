require 'configatron'

Configatron::Integrations::Rails.init

Rocketboard.set_config(configatron)