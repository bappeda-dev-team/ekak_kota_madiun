module Api
  class PohonKinerjaController < ActionController::API
    before_action :set_tahun_opd
    respond_to :json

    def pohon_kinerja_opd
      @opd = queries.opd
      @nama_opd = @opd.nama_opd

      @strategi_opd = queries.strategi_opd
      @tactical_opd = queries.tactical_opd
      @operational_opd = queries.operational_opd
      @staff_opd = queries.staff_opd
    end

    private

    def queries
      PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)
    end

    def set_tahun_opd
      @tahun = params[:tahun]
      @kode_opd = params[:kode_opd]
      @opd = queries.opd
    end
  end
end
