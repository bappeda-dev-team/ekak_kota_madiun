RailsPerformance.setup do |config|
  config.redis = Redis::Namespace.new("#{Rails.env}-rails-performance", redis: Redis.new)
  config.duration = 4.hours

  config.debug = false # currently not used>
  config.enabled = true

  # default path where to mount gem

  # protect your Performance Dashboard with HTTP BASIC password
  config.http_basic_authentication_enabled   = false
  # config.http_basic_authentication_user_name = 'rails_performance'
  # config.http_basic_authentication_password  = 'password12'

  # if you need an additional rules to check user permissions
  # for example when you have `current_user`

  # You can ignore endpoints with Rails standard notation controller#action
  # config.ignored_endpoints = ['HomeController#contact']

  # config home button link
  config.home_link = '/'
  config.skipable_rake_tasks = ['webpacker:compile']

end if defined?(RailsPerformance)
