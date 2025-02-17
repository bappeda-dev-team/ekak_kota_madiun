require "capybara/rspec"
require 'capybara/rails'
Capybara.register_driver :selenium_debug_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  %w[
    incognito
    disable-extensions
    window-size=1920,1080
  ].each { options.add_argument _1 }

  %w[
    headless disable-gpu
  ].each { options.add_argument _1 } if %w[1 on true]
                                        .include?(ENV['HEADLESS'])
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

ShowMeTheCookies.register_adapter(:selenium_debug_chrome, ShowMeTheCookies::Selenium)

RSpec.configure do |config|
  # config.use_transactional_fixtures = false

  # Capybara
  config.include Capybara::DSL
  config.include CapybaraSelect2
  config.include CapybaraSelect2::Helpers # if need specific helpers
  config.include ShowMeTheCookies, type: :feature

  config.before(:each, type: :feature) do
    Capybara.current_driver = :rack_test
  end

  config.before(:each, type: :feature, js: true) do
    Capybara.current_driver = :selenium_debug_chrome
    ApplicationController.allow_forgery_protection = true
  end
end
