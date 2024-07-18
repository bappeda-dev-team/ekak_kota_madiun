source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'bullet'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'debug'
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'rails-controller-testing'
  gem 'rspec-core'
  gem 'rspec-rails', '~> 6.1.0'
  gem 'ruby-lsp-rails', require: false
  gem 'ruby-lsp-rspec', require: false
  gem 'shoulda-matchers', '~> 5.0'
end

group :development do
  gem 'annotate'
  # capistrano thing
  gem 'capistrano', '~> 3.11', require: false
  gem 'capistrano-passenger', '~> 0.2.0', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'htmlbeautifier'
  gem 'letter_opener'
  gem 'listen', '~> 3.3'
  gem 'query_diet'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'rubocop-rails', require: false
  gem 'solargraph'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'capybara-select-2'
  gem 'database_cleaner'
  gem 'fuubar'
  gem 'selenium-webdriver'
  gem 'show_me_the_cookies'
end

gem 'active_link_to'
gem 'any_login'
gem 'cancancan'
gem 'caxlsx'
gem 'caxlsx_rails'
gem 'clowne'
gem 'devise'
gem 'http'
gem 'memoist'
gem 'oauth2'
gem 'oj'
gem 'online_migrations'
gem 'pagy', '~> 5.10'
gem 'prawn'
gem 'prawn-markup'
gem 'prawn-rails', '~> 1.4', '>= 1.4.2'
gem 'prawn-table'
gem 'rack-cors'
gem 'rails_performance'
gem 'redis'
gem 'rolify', '~> 6.0'
gem 'sassc-rails'
gem 'scenic'
gem 'sidekiq'
gem 'sidekiq-unique-jobs'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'vanilla_nested', github: 'arielj/vanilla-nested', branch: "support-3-level-nesting"
gem "view_component"
gem 'wdm', '>= 0.1.0' if Gem.win_platform?
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
