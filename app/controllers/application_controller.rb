class ApplicationController < ActionController::Base
  add_flash_types :success, :error
  include Pagy::Backend
  before_action :authenticate_user!
end
