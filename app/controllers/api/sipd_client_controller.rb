# frozen_string_literal: true

# used for handling Sipd Service, synchronize Program etc
# params : kode_opd: opd.id_opd_skp, tahun: Date.today.year
module Api
  class SipdClientController < ApplicationController
    before_action :set_program_params, except: [:sync_musrenbang, :sync_pokpir]
    def sync_subkegiatan
      UpdateProgramJob.set(queue: "#{nama_opd}-#{@kode_opd}-renstra-#{@tahun}").perform_later(@kode_opd, @tahun, @id_opd)
      redirect_to admin_program_kegiatan_path,
                  success: "Update ProgramKegiatan #{nama_opd} Dikerjakan. Harap menunggu..."
    end

    def sync_musrenbang
      UpdateMusrenbangJob.set(queue: "Musrenbang-#{@tahun}").perform_later(@tahun)
      redirect_to musrenbangs_path, success: "Update Musrenbang #{@tahun} Dikerjakan. Harap menunggu..."
    end

    def sync_pokpir
      UpdatePokpirJob.set(queue: "PokokPikiran-#{@tahun}").perform_later(@tahun)
      redirect_to pokpirs_path, success: "Update Usulan Pokok Pikiran #{@tahun} Dikerjakan. Harap menunggu..."
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
                  error: "Harap Sync Sasaran #{nama_opd} dahulu"
      end
      @id_opd = Opd.find_by(id_opd_skp: @kode_opd).kode_opd
    end
  end
end
