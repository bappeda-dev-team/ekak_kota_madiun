module Api
  class PaguController < ApplicationController
    def sync_penetapan
      @tahun_asli = cookies[:tahun]
      kode_opd = cookies[:opd]
      @tahun = @tahun_asli.gsub('_perubahan', '')
      # WARNING: HARD CODED BULAN
      @bulan = DateTime.current.month
      @opd = Opd.find_by(kode_unik_opd: kode_opd)
      @kode_unik_opd = @opd.kode_unik_opd
      @kode_opd = @opd.kode_opd

      SyncPenetapanJob.perform_async(@kode_unik_opd, @tahun, @bulan, @kode_opd, @tahun_asli)

      flash.now[:success] = "Sinkronisasi Pagu Penetapan Dikerjakan."
      render 'shared/_notifikasi_simple'
    end

    def sync_pagu_kak
      @tahun = cookies[:tahun]
      @kode_opd = cookies[:opd]

      SyncPaguKakJob.perform_async(@tahun, @kode_opd)

      flash.now[:success] = "Sinkronisasi Pagu KAK Dikerjakan."
      render 'shared/_notifikasi_simple'
    end

    def sync_opd
      @tahun_asli = cookies[:tahun]
      kode_opd = cookies[:opd]
      @tahun = @tahun_asli.gsub('_perubahan', '')
      # WARNING: HARD CODED BULAN
      @bulan = DateTime.current.month
      @opd = Opd.find_by(kode_unik_opd: kode_opd)
      @kode_unik_opd = @opd.kode_unik_opd
      @kode_opd = @opd.kode_opd

      SyncPaguOpdJob.perform_async(@kode_unik_opd, @tahun, @bulan, @kode_opd, @tahun_asli)

      flash.now[:success] = "Sinkronisasi Pagu OPD Dikerjakan."
      render 'shared/_notifikasi_simple'
    end
  end
end
