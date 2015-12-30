Sidekiq.configure_client do |config|
  config.redis = {url: "#{Rocketboard.config.redis.url}", namespace: "#{Rails.env}", network_timeout: 5}
end

Sidekiq.configure_server do |config|
  config.redis = {url: "#{Rocketboard.config.redis.url}", namespace: "#{Rails.env}", network_timeout: 5}
end