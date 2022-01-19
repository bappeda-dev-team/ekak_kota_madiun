class HomeController < ApplicationController

  def dashboard
    @sasaran = current_user.sasarans.all
    @total_progress = @sasaran.map{ |s| s.rincian.progress_total  }.sum
    @avg_progress = @total_progress / @sasaran.count
    render 'dashboard'
  end
end
