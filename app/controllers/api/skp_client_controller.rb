# frozen_string_literal: true

module Api
  # Controller for SKP API
  class SkpClientController < ApplicationController
    before_action :set_params
    before_action :verify_kode_opd, only: [:sync_sasaran]

    def sync_sasaran
      UpdateSkpJob.perform_later(@kode_opd, @tahun, @bulan)
      redirect_to adminsasarans_path,
                  success: "Update Sasaran #{nama_opd} Dikerjakan..."
    end

    def sync_pegawai
      UpdateUserJob.perform_later(@kode_opd, @tahun, @bulan)
      redirect_to adminusers_path, success: "Update Pegawai #{nama_opd} Dikerjakan..."
    end

    private

    def verify_kode_opd
      user = User.find_by(kode_opd: @kode_opd).nil?
      if user
        redirect_to adminsasarans_path, error: "Harap update pegawai #{nama_opd} terlebih dahulu" 
      end
    end

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
