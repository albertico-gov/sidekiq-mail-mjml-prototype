# config/sidekiq.rb

Sidekiq.configure_server do |config|
  config.redis = { :host => ENV['REDIS_HOST'], :port => ENV['REDIS_PORT'], :db => ENV['REDIS_DB'] }
end

Sidekiq.configure_client do |config|
  config.redis = { :host => ENV['REDIS_HOST'], :port => ENV['REDIS_PORT'], :db => ENV['REDIS_DB'] }
end
