# frozen_string_literal: true

module Api
  # Controller for SKP API
  class SkpClientController < ApplicationController
    before_action :set_params
    def sync_sasaran
      request = Api::SkpClient.new(@kode_opd, @tahun, @bulan)
      request.update_sasaran
      redirect_to adminsasarans_path
    end

    def sync_pegawai
      request = Api::SkpClient.new(@kode_opd, @tahun, @bulan)
      request.update_pegawai
      redirect_to adminusers_path
    end

    def set_params
      # @kode_opd = params[:kode_opd]
      @kode_opd = '5.01.5.05.0.00.02.0000' # Warning Hardcoded to only bappeda, create some filter to do this
      @tahun = params[:tahun]
      @bulan = params[:bulan]
    end
  end
end
