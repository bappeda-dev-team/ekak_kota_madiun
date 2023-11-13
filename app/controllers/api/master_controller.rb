module Api
  class MasterController < ActionController::API
    respond_to :json

    def usulan_musrenbang
      @tahun = params[:tahun]
      # kode_unik_opd = params[:kode_opd]
      # opd = Opd.find_by(kode_unik_opd: kode_unik_opd)
      @musrenbangs = Musrenbang.where(tahun: @tahun)
                               .order(:updated_at)
    end

    def create_usulan_musrenbang
      @musrenbang = Musrenbang.new(musrenbang_params)

      if @musrenbang.save
        render json: { resText: "Entri Musrenbang ditambahkan" }.to_json,
               status: :created
      else
        render json: { resText: "Terjadi kesalahan", errors: @musrenbang.errors }.to_json,
               status: :unprocessable_entity
      end
    end

    def delete_usulan_musrenbang
      Musrenbang.find(params[:musrenbang][:id]).destroy!

      head :no_content
    end

    def usulan_mandatori
      @tahun = params[:tahun]
      kode_unik_opd = params[:kode_opd]
      opd = Opd.find_by!(kode_unik_opd: kode_unik_opd)
      @mandatoris = Mandatori.includes(:user).where(user: { kode_opd: opd.kode_opd })
    end

    def usulan_inisiatif
      @tahun = params[:tahun]
      kode_unik_opd = params[:kode_opd]
      opd = Opd.find_by(kode_unik_opd: kode_unik_opd)
      @inovasis = Inovasi.includes(:user).where(user: { kode_opd: opd.kode_opd })
    end

    def usulan_spbe; end

    def usulan_lppd; end

    def usulan_spm; end

    private

    def musrenbang_params
      params.require(:musrenbang).permit(:tahun, :usulan, :uraian, :alamat, :opd)
    end
  end
end
