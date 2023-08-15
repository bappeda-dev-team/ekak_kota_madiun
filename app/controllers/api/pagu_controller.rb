module Api
  class PaguController < ApplicationController
    def sync_penetapan
      @opd = Opd.find(params[:opd_id])
      @kode_unik_opd = @opd.kode_unik_opd
      @kode_opd = @opd.kode_opd
    end
  end
end
