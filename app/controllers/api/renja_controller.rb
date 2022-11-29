module Api
  class RenjaController < ApplicationController
    include Renstra::OpdKhusus

    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!
    before_action :set_params

    def opd_program
      @jenis = 'program'
      @opd = Opd.find_by(kode_unik_opd: @kode_opd)
      @programs = @opd.program_renstra
      @program_kegiatans = Renja.new(jenis: @jenis,
                                     kode: 'program', tipe: 'program',
                                     tahun: @tahun)
                                .indikator_programs_opd(opd: @opd, program_kegiatans_by_opd: @programs)
      respond_to { |f| f.json { render 'opd_test_indikator' } }
    end

    def opd_kegiatan
      @jenis = 'kegiatan'
      @opd = Opd.find_by(kode_unik_opd: @kode_opd)
      @programs = @opd.kegiatans_renstra
      @program_kegiatans = Renja.new(jenis: @jenis,
                                     kode: 'giat', tipe: 'kegiatan',
                                     tahun: @tahun)
                                .indikator_programs_opd(opd: @opd, program_kegiatans_by_opd: @programs)
      respond_to { |f| f.json { render 'opd_test_indikator' } }
    end

    def opd_subkegiatan
      @jenis = 'subkegiatan'
      @opd = Opd.find_by(kode_unik_opd: @kode_opd)
      @programs = @opd.subkegiatans_renstra
      @program_kegiatans = Renja.new(jenis: @jenis,
                                     kode: 'sub_giat', tipe: 'subkegiatan',
                                     tahun: @tahun)
                                .indikator_programs_opd(opd: @opd, program_kegiatans_by_opd: @programs)
      respond_to { |f| f.json { render 'api/programs/opd_test_indikator' } }
    end

    # kota ( all opd )
    def kota_indikator_program
      @jenis = 'program'
      @program_kegiatans = Renja.new(jenis: @jenis,
                                     kode: 'program', tipe: 'program',
                                     tahun: @tahun)
                                .program_kota(jenis_program_kegiatan: 'program_renstra')
      respond_to { |f| f.json { render 'kota_test_indikator' } }
    end

    def kota_indikator_kegiatan
      @jenis = 'kegiatan'
      @program_kegiatans = Renja.new(jenis: @jenis,
                                     kode: 'giat', tipe: 'kegiatan',
                                     tahun: @tahun)
                                .program_kota(jenis_program_kegiatan: 'kegiatans_renstra')
      respond_to { |f| f.json { render 'kota_test_indikator' } }
    end

    def kota_indikator_subkegiatan
      @jenis = 'subkegiatan'
      @program_kegiatans = Renja.new(jenis: @jenis,
                                     kode: 'sub_giat', tipe: 'subkegiatan',
                                     tahun: @tahun)
                                .program_kota(jenis_program_kegiatan: 'subkegiatans_renstra')
      respond_to { |f| f.json { render 'kota_test_indikator' } }
    end

    def kode_program
      params[:kode_program]
    end

    def bidang_checker(nama_opd)
      OPD_TABLE.values_at(nama_opd.to_sym)
    end

    private

    def set_params
      @kode_opd = params[:kode_opd]
      @tahun = params[:tahun]
      @jenis = params[:jenis]
    end
  end
end
