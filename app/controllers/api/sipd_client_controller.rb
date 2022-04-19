# frozen_string_literal: true

# this module not used yet
# used for handling Sipd Service, synchronize Program etc
module Api
  class SipdClientController < ApplicationController
    def sync_subkegiatan
      tahun = params[:tahun]
      kode_opd = params[:kode_opd]
      id_opd = Opd.find_by(id_opd_skp: kode_opd).kode_opd
      UpdateProgramJob.perform_later(kode_opd, tahun, id_opd)
      redirect_to admin_program_kegiatan_path,
                  notice: "Update ProgramKegiatan Dikerjakan..."
    end
  end
end
