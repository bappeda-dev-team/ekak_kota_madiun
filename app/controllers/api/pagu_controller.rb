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
      kode_tombol = params[:kode_tombol]

      SyncPaguKakJob.perform_async(@tahun, @kode_opd)

      update_tombol(kode_tombol: kode_tombol, tahun: @tahun, kode_opd: @kode_opd, tombol: 'Sync Pagu KAK')

      flash.now[:success] = "Sinkronisasi Pagu KAK Dikerjakan."
      render 'shared/_notifikasi_simple'
    end

    def sync_opd # rubocop:disable Metrics/AbcSize
      @tahun_asli = cookies[:tahun]
      kode_opd = cookies[:opd]
      kode_tombol = params[:kode_tombol]
      @tahun = @tahun_asli.gsub('_perubahan', '')
      # WARNING: HARD CODED BULAN
      @bulan = DateTime.current.month
      @opd = Opd.find_by(kode_unik_opd: kode_opd)
      @kode_unik_opd = @opd.kode_unik_opd
      @kode_opd = @opd.kode_opd

      SyncPaguOpdJob.perform_async(@kode_unik_opd, @tahun, @bulan, @kode_opd, @tahun_asli)

      update_tombol(kode_tombol: kode_tombol, tahun: @tahun_asli, kode_opd: kode_opd, tombol: 'Sync Pagu')

      flash.now[:success] = "Sinkronisasi Pagu OPD Dikerjakan."
      render 'shared/_notifikasi_simple'
    end

    private

    def update_tombol(kode_tombol:, tahun:, kode_opd:, tombol:)
      status_tombol = StatusTombol.find_by(
        kode_tombol: kode_tombol,
        tahun: tahun,
        kode_opd: kode_opd
      )
      if status_tombol.nil?
        StatusTombol.create(
          kode_tombol: kode_tombol,
          tahun: tahun,
          kode_opd: kode_opd,
          disabled: true,
          tombol: tombol
        )
      else
        status_tombol.update(disabled: true)
      end
    end
  end
end
