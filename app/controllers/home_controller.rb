class HomeController < ApplicationController

  def homepage
    render 'index'
  end

  def dashboard
    render 'dashboard'
  end
end
