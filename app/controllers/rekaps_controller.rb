class RekapsController < ApplicationController
  # before_action :kode_opd

  def jumlah
    # dummy kode
    # kode_opd = '5.01.5.05.0.00.02.0000'
    @rekaps = []
    Opd.includes([:program_kegiatans]).where.not(program_kegiatans: { kode_opd: nil }).each do |opd|
      @rekaps << Rekap.new(kode_unik_opd: opd.kode_unik_opd).jumlah_rekap
    end
    @rekaps
  end

  def kode_opd_params
    params[:opd]
  end
end
