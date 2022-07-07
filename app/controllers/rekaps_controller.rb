class RekapsController < ApplicationController
  # before_action :kode_opd

  def jumlah
    # dummy kode
    @rekaps = []
    if kode_opd_params.present?
      @rekaps << Rekap.new(kode_unik_opd: kode_opd_params).jumlah_rekap
    else
      Opd.includes([:program_kegiatans]).where.not(program_kegiatans: { kode_opd: nil }).each do |opd|
        @rekaps << Rekap.new(kode_unik_opd: opd.kode_unik_opd).jumlah_rekap
      end
    end
    @rekaps
  end

  def kode_opd_params
    params[:opd]
  end
end
