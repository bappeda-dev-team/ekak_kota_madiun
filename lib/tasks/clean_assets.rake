#!/usr/bin/env ruby

namespace :assets do
  desc "Clean assets in test environment"
  task clean_test: :environment do
    if Rails.env.test?
      Rake::Task["assets:clobber"].invoke
      Rake::Task["assets:precompile"].invoke
      puts "✅ Assets cleaned and recompiled in test environment."
    else
      puts "⛔ This task only runs in the test environment."
    end
  end
end
