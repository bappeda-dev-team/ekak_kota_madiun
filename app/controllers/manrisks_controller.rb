class ManrisksController < ApplicationController
  before_action :set_periode_pemda

  def konteks_strategis
    @tujuan_kota = TujuanKota.by_periode(@tahun)
  end

  private

  def set_periode_pemda
    @tahun = cookies[:tahun]
    @pemda = cookies[:lembaga]
    @periode = Periode.find_tahun(@tahun)
    @tahun_awal = @periode.tahun_awal.to_i
    @tahun_akhir = @periode.tahun_akhir.to_i
  end
end
