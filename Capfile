# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Load the SCM plugin appropriate to your project:
#
# require "capistrano/scm/hg"
# install_plugin Capistrano::SCM::Hg
# or
# require "capistrano/scm/svn"
# install_plugin Capistrano::SCM::Svn
# or
require "capistrano/scm/git"
require 'capistrano/rails'
require 'capistrano/passenger'
require 'capistrano/rbenv'
require 'capistrano/sidekiq'

install_plugin Capistrano::SCM::Git

install_plugin Capistrano::Sidekiq
install_plugin Capistrano::Sidekiq::Systemd

set :rbenv_type, :user
set :rbenv_ruby, '3.0.1'

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
