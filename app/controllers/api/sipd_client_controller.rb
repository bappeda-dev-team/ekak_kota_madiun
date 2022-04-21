# frozen_string_literal: true

# used for handling Sipd Service, synchronize Program etc
module Api
  class SipdClientController < ApplicationController
    before_action :set_program_params
    def sync_subkegiatan
      UpdateProgramJob.perform_later(@kode_opd, @tahun, @id_opd)
      redirect_to admin_program_kegiatan_path,
                  success: "Update ProgramKegiatan #{nama_opd} Dikerjakan..."
    end

    private

    def nama_opd
      Opd.find_by(id_opd_skp: @kode_opd).nama_opd
    end

    def set_program_params
      @kode_opd = params[:kode_opd]
      @tahun = params[:tahun]
      if @kode_opd.nil?
        redirect_to admin_program_kegiatan_path,
                  alert: "Harap Sync Sasaran dahulu"
      end
      @id_opd = Opd.find_by(id_opd_skp: @kode_opd).kode_opd
    end
  end
end
