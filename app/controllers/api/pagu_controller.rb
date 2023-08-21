module Api
  class PaguController < ApplicationController
    def sync_penetapan
      @tahun_asli = cookies[:tahun]
      @tahun = @tahun_asli.gsub('_perubahan', '')
      # WARNING: HARD CODED BULAN
      @bulan = 3
      @opd = Opd.find(params[:opd_id])
      @kode_unik_opd = @opd.kode_unik_opd
      @kode_opd = @opd.kode_opd

      SyncPenetapanJob.perform_async(@kode_unik_opd, @tahun, @bulan, @kode_opd, @tahun_asli)

      flash.now[:success] = "Sinkronisasi Pagu Penetapan Dikerjakan."
      render 'shared/_notifikasi_simple'
    end
  end
end
