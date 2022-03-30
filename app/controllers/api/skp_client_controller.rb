# frozen_string_literal: true

module Api
  # Controller for SKP API
  class SkpClientController < ApplicationController
    before_action :set_params
    def sync_sasaran
      UpdateSkpJob.perform_later(@kode_opd, @tahun, @bulan)
      redirect_to adminsasarans_path,
                  notice: "Update SKP #{@kode_opd} Bulan #{@bulan} Tahun #{@tahun}, sedang diproses"
    end

    def sync_pegawai
      request = Api::SkpClient.new(@kode_opd, @tahun, @bulan)
      request.update_pegawai
      redirect_to adminusers_path
    end

    def set_params
      @kode_opd = params[:kode_opd]
      # @kode_opd = '2.16.2.20.2.21.04.0000' # Warning Hardcoded to only bappeda, create some filter to do this
      @tahun = params[:tahun]
      @bulan = params[:bulan]
    end
  end
end
