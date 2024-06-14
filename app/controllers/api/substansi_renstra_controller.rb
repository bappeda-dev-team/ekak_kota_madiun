module Api
  class SubstansiRenstraController < ActionController::API
    respond_to :json

    def strategi_arah_kebijakan
      @tahun = params[:tahun]
      @kode_opd = params[:kode_opd]
      strategi_arah_kebijakan = StrategiArahKebijakan.new(tahun: @tahun, kode_opd: @kode_opd)
      @opd = strategi_arah_kebijakan.opd
      @tujuan_opds = strategi_arah_kebijakan.tujuan_opds
      @strategi_opds = strategi_arah_kebijakan.tujuan_strategi_opds
      @tactical_opds = strategi_arah_kebijakan.tactical_opds
      @isu_strategis_opds = strategi_arah_kebijakan.isu_strategis_opds
    end
  end
end
