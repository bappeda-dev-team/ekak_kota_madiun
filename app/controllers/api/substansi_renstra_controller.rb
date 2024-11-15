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

      @dasar_hukums = sasarans.flat_map(&:dasar_hukum_sasaran).sort_by(&:urutan)
    end

    def asets
      @tahun = params[:tahun]
      @kode_opd = params[:kode_opd]
      @opd = Opd.find_by(kode_unik_opd: @kode_opd)
      @asets = @opd.aset_opd(@tahun)
    end

    def sumber_daya_manusia
      @tahun = params[:tahun]
      @kode_opd = params[:kode_opd]
      @opd = Opd.find_by(kode_unik_opd: @kode_opd)
      @jabatans = @opd.jabatan_baru
    end

    def akar_masalah
      @tahun = params[:tahun]
      @kode_opd = params[:kode_opd]
      queries = PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)
      @opd = queries.opd
      @nama_opd = @opd.nama_opd
      @strategi_opds = queries.strategi_opd
    end

    def isu_strategis
      @kode_opd = params[:kode_opd]
      @tahun = params[:tahun]
      @opd = Opd.find_by(kode_unik_opd: @kode_opd)
      @nama_opd = @opd.nama_opd
      tahun_asli = @tahun.include?('perubahan') ? @tahun.gsub('_perubahan', '') : @tahun
      @isu_strategis = @opd.isu_strategis_opds
                           .where("tahun ILIKE ?", "%#{tahun_asli}%")
                           .order(:id)
    end
  end
end
