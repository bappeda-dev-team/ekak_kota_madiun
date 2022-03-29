# frozen_string_literal: true

module Api
  # Controller for SKP API
  class SkpClientController < ApplicationController
    before_action :set_params
    def sync_sasaran
      request = Api::SkpClient.new(@kode_opd, @tahun, @bulan)
      render json: request.data_sasaran_asn_opd
    end

    def sync_pegawai
      request = Api::SkpClient.new(@kode_opd, @tahun, @bulan)
      request.update_pegawai
      redirect_to adminusers_path
    end

    def set_params
      # @kode_opd = params[:kode_opd]
      @kode_opd = '5.01.5.05.0.00.02.0000'
      @tahun = params[:tahun]
      @bulan = params[:bulan]
    end
  end
end
