options = {
  servers: "#{Rocketboard.config.redis.url}/session",
  expires_in: 1.hour,
  domain: :all
}

Rails.application.config.session_store(:redis_store, options)