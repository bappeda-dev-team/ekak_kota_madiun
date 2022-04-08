# frozen_string_literal: true

module Api
  # Controller for SKP API
  class SkpClientController < ApplicationController
    before_action :set_params
    def sync_sasaran
      UpdateSkpJob.perform_later(@kode_opd, @tahun, @bulan)

      redirect_to adminsasarans_path,
                  notice: "Update Sasaran #{nama_opd} Dikerjakan..."
    end

    def sync_pegawai
      UpdateUserJob.perform_later(@kode_opd, @tahun, @bulan)
      redirect_to adminusers_path, notice: "Update Pegawai #{nama_opd} Dikerjakan..."
    end

    private

    def nama_opd
      Opd.find_by(kode_unik_opd: @kode_opd).nama_opd
    end

    def set_params
      @kode_opd = params[:kode_opd]
      @tahun = params[:tahun]
      @bulan = params[:bulan]
    end
  end
end
