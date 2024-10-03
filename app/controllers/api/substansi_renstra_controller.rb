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

    def dasar_hukums
      @tahun = params[:tahun]
      @kode_opd = params[:kode_opd]
      @opd = Opd.find_by(kode_unik_opd: @kode_opd)
      sasarans = @opd.sasarans
                     .includes(%i[user
                                  mandatoris
                                  dasar_hukums
                                  program_kegiatan])
                     .where(tahun: @tahun)
                     .order(nip_asn: :asc)
                     .dengan_sub_kegiatan
                     .dengan_strategi

      @dasar_hukums = sasarans.flat_map do |sasaran|
        sasaran.all_dasar_hukum(@tahun)
      end.uniq.compact_blank
    end
  end
end
