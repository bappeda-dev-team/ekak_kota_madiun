module Api
  class SipdClientController < ApplicationController
    # FIXME : This is a temporary solution
    # saat sync_sasaran di hit, lakukan background processing untuk mengambil data di SKP, lalu refresh halaman dan
    def sync_sasaran
      kode_opd = params[:kode_opd]
      tahun = params[:tahun]
      bulan = params[:bulan]
      request = Api::SkpClient.new(kode_opd, bulan, tahun)
      render inline: request.data_sasaran_asn_opd
    end
  end
end
