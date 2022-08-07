class HomeController < ApplicationController
  def dashboard
    @tahun_sasaran = cookies[:tahun_sasaran] || '2023'
    @sasarans = current_user.sasarans.where(tahun: @tahun_sasaran).order(:id)
  end
end
