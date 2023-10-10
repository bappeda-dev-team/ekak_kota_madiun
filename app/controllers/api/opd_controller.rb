module Api
  class OpdController < ActionController::API
    respond_to :json

    def daftar_opd
      @opds = Opd.where.not(kode_unik_opd: nil)
    end

    def find_opd
      nama_opd = params[:q]
      @opds = Opd.where('nama_opd ILIKE ?', "%#{nama_opd}%")
      render 'daftar_opd'
    end

    def with_bidang
      @opds = Opd.where(has_bidang: true)
    end

    def urusan_opd
      @opds = Opd.where.not(kode_unik_opd: nil)
                 .where.not(urusan: [nil, ''])
    end
  end
end
