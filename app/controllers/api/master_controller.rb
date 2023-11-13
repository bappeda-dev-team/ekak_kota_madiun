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

    def usulan_pokir
      @tahun = params[:tahun]
      # kode_unik_opd = params[:kode_opd]
      # opd = Opd.find_by(kode_unik_opd: kode_unik_opd)
      @pokpirs = Pokpir.where(tahun: @tahun)
                       .order(:updated_at)
    end

    def usulan_mandatori
      @tahun = params[:tahun]
      kode_unik_opd = params[:kode_opd]
      opd = Opd.find_by(kode_unik_opd: kode_unik_opd)
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
  end
end
