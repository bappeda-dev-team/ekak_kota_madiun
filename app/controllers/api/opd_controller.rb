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

    def tujuan_opd
      @opd = Opd.find_by!(kode_unik_opd: params[:kode_opd])
      @tujuan_opds = @opd.tujuan_opds.includes(%i[indikators])
    rescue ActiveRecord::RecordNotFound
      @error = "Opd tidak ditemukan"
      render json: { message: "terjadi kesalahan", errors: @error }.to_json,
             status: :not_found
    end
  end
end
