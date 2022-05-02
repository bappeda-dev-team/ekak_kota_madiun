class HomeController < ApplicationController
  def dashboard
    @sasaran = current_user.sasarans.all
    render 'dashboard'
  end
end
