class HomeController < ApplicationController

  def dashboard
    @sasaran = current_user.sasarans.all
    @total_progress = current_user.total_user_progress
    @avg_progress = current_user.avg_user_progress
    @chart = current_user.generate_chart_value
    @chart_real = current_user.generate_chart_value_realisasi
    render 'dashboard'
  end
end
