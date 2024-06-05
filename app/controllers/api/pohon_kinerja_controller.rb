module Api
  class PohonKinerjaController < ActionController::API
    before_action :set_tahun
    respond_to :json

    def pohon_kinerja_opd
      @opd = queries.opd
      @nama_opd = @opd.nama_opd

      @pohons = queries.all_strategi_opd
    end

    def pohon_kinerja_kota
      @pohon = queries_kota
      @tema = @pohon.tematiks.reject { |ph| ph.pohonable.nil? }
      @sub_tematiks = @pohon.sub_tematiks.reject { |ph| ph.pohonable.nil? }
      @sub_sub_tematiks = @pohon.sub_sub_tematiks.reject { |ph| ph.pohonable.nil? }
      @strategics = @pohon.strategi_tematiks.reject { |ph| ph.pohonable.nil? }
      @tacticals = @pohon.tactical_tematiks.reject { |ph| ph.pohonable.nil? }
      @operationals = @pohon.operational_tematiks.reject { |ph| ph.pohonable.nil? }
    end

    private

    def queries
      @kode_opd = params[:kode_opd]
      PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)
    end

    def queries_kota
      PohonTematikQueries.new(tahun: @tahun)
    end

    def set_tahun
      @tahun = params[:tahun]
    end
  end
end
