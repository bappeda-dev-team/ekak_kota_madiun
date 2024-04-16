# frozen_string_literal: true

# update Sasaran dan User dari SKP
# params: kode_opd: kode_opd, tahun: Date.today.year, bulan: Date.today.month

module Api
  # Controller for SKP API
  class SkpClientController < ApplicationController
    before_action :set_params
    before_action :verify_kode_opd, only: [:sync_sasaran]

    def sync_pegawai
      UpdateUserJob.perform_later(@kode_opd, @tahun, @bulan)
      flash.now[:success] = "Update Pegawai #{nama_opd} Dikerjakan. Harap menunggu..."
      render 'shared/_notifikasi_simple'
    end

    def sync_jabatan
      kode_tombol = params[:kode_tombol]
      SyncJabatanJob.perform_async(@kode_opd, @tahun)

      # update_tombol(kode_tombol: kode_tombol, tahun: @tahun, kode_opd: @kode_opd, tombol: 'Sync Jabatan')

      flash.now[:success] = "Sinkronisasi Jabatan dikerjakan.."
      render 'shared/_notifikasi_simple'
    end

    private

    def nama_opd
      Opd.find_by(kode_unik_opd: @kode_opd).nama_opd
    end

    def set_params
      @kode_opd = params[:kode_opd]
      @tahun = params[:tahun]
      @bulan = params[:bulan]
      @nip_asn = params[:nip_asn]
    end

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
