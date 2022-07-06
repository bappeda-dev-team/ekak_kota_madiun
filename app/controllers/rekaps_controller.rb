class RekapsController < ApplicationController
  def jumlah
    # dummy kode
    kode_opd = ''
    @rekaps = Rekap.new(kode_unik_opd: kode_opd).rekap_jumlah
  end
end
