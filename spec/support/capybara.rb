# require "capybara/rspec"

RSpec.configure do |config|
  # config.use_transactional_fixtures = false

  # Capybara
  config.include Capybara::DSL
  config.include CapybaraSelect2
  config.include CapybaraSelect2::Helpers # if need specific helpers
  config.include ShowMeTheCookies, type: :system

  config.before(:each, type: :system) do
    driven_by :rack_test
    Capybara.current_driver = :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_headless
    Capybara.current_driver = :selenium_headless
  end
  # config.before(:suite) do
  #   DatabaseCleaner.clean_with(:truncation)
  # end

  # config.before(:each) { DatabaseCleaner.strategy = :transaction }

  # config.before(:each, type: :feature) do
  #   # :rack_test driver's Rack app under test shares database connection
  #   # with the specs, so continue to use transaction strategy for speed.
  #   driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

  #   unless driver_shares_db_connection_with_specs
  #     # Driver is probably for an external browser with an app
  #     # under test that does *not* share a database connection with the
  #     # specs, so use truncation strategy.
  #     DatabaseCleaner.strategy = :truncation
  #   end
  # end

  # config.before(:each, type: :feature, js: true) do
  #   Capybara.current_driver = :selenium
  # end

  # config.before(:each, type: :feature, js: true, headless: true) do
  #   Capybara.current_driver = :selenium_headless
  # end

  # config.before(:each) { DatabaseCleaner.start }

  # config.append_after(:each) { DatabaseCleaner.clean }
end
