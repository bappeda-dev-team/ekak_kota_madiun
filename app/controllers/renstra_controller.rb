class RenstraController < ApplicationController
  before_action :set_renstra
  def index
    base_data = KakService.new(tahun: 2022, kode_unik_opd: @kode_unik_opd)
  end

  def set_renstra
    @kode_unik_opd = params[:kode_unik_opd]
    @tahun = params[:tahun]
  end
end
