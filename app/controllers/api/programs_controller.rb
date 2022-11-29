module Api
  class ProgramsController < ApplicationController
    include Renstra::OpdKhusus

    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!
    before_action :set_params

    def indikators
      @kode_opd = params[:kode_opd]
      opd = Opd.find_by(kode_unik_opd: @kode_opd).nama_opd
      @program_kegiatans = ProgramKegiatan
                           .includes(:opd)
                           .select("DISTINCT ON(program_kegiatans.kode_program) program_kegiatans.*")
                           .where(opds: { kode_unik_opd: @kode_opd })
                           .where(kode_program: kode_program)
      if OPD_TABLE.key?(opd.to_sym)
        @program_kegiatans = ProgramKegiatan.includes(:opd)
                                            .select("DISTINCT ON(program_kegiatans.kode_program) program_kegiatans.*")
                                            .where(id_sub_unit: KODE_OPD_BAGIAN[opd.to_sym])
                                            .where(kode_program: kode_program)
      end
      respond_to do |format|
        format.json { render 'program_kegiatans/filter_program' }
      end
    end

    def permasalahans
      @kode_opd = params[:kode_opd]
      @tahun = params[:tahun]
      @program_kegiatans = KakService.new(kode_unik_opd: @kode_opd, tahun: @tahun).isu_strategis
      respond_to do |format|
        format.json { render 'program_kegiatans/permasalahans' }
      end
    end

    def opd_program
      # @tahun = @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
      opd = Opd.find_by(kode_unik_opd: @kode_opd).nama_opd

      @program_kegiatans = ProgramKegiatan.includes(:opd)
                                          .select("DISTINCT ON(program_kegiatans.kode_program) program_kegiatans.*")
                                          .where(opds: { kode_unik_opd: @kode_opd })
      if OPD_TABLE.key?(opd.to_sym)
        @program_kegiatans = ProgramKegiatan.includes(:opd)
                                            .select("DISTINCT ON(program_kegiatans.kode_program) program_kegiatans.*")
                                            .where(id_sub_unit: KODE_OPD_BAGIAN[opd.to_sym])
                                            .where(tahun: @tahun)
      end
      respond_to do |format|
        format.json { render 'opd_program' }
      end
    end

    def opd_kegiatan
      # @tahun = @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
      opd = Opd.find_by(kode_unik_opd: @kode_opd).nama_opd
      @program_kegiatans = ProgramKegiatan.includes(:opd)
                                          .select("DISTINCT ON(program_kegiatans.kode_giat) program_kegiatans.*")
                                          .where(opds: { kode_unik_opd: @kode_opd })
                                          .where(tahun: @tahun)
      if OPD_TABLE.key?(opd.to_sym)
        @program_kegiatans = ProgramKegiatan.includes(:opd)
                                            .select("DISTINCT ON(program_kegiatans.kode_giat) program_kegiatans.*")
                                            .where(id_sub_unit: KODE_OPD_BAGIAN[opd.to_sym])
                                            .where(tahun: @tahun)
      end
      respond_to do |format|
        format.json { render 'opd_kegiatan' }
      end
    end

    def opd_subkegiatan
      opd = Opd.find_by(kode_unik_opd: @kode_opd).nama_opd
      # @tahun = @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
      @program_kegiatans = ProgramKegiatan.order(:id).includes(%i[opd])
                                          .where(opds: { kode_unik_opd: @kode_opd })
                                          .where(tahun: @tahun)
      if OPD_TABLE.key?(opd.to_sym)
        @program_kegiatans = ProgramKegiatan.order(:id).includes(%i[opd])
                                            .where(id_sub_unit: KODE_OPD_BAGIAN[opd.to_sym])
                                            .where(tahun: @tahun)
      end
      respond_to do |format|
        format.json { render 'opd_subkegiatan' }
      end
    end

    def opd_test_renstra_program
      programs = KakService.new(kode_unik_opd: @kode_opd, tahun: @tahun)
      @program_kegiatans = programs.indikator_renstra_programs_opd(jenis: 'program', kode: 'program', nama: 'program')
      respond_to { |f| f.json { render 'opd_test_indikator' } }
    end

    def opd_test_renstra_kegiatan
      programs = KakService.new(kode_unik_opd: @kode_opd, tahun: @tahun)
      @program_kegiatans = programs.indikator_renstra_programs_opd(jenis: 'kegiatan', kode: 'giat', nama: 'kegiatan')
      respond_to { |f| f.json { render 'opd_test_indikator' } }
    end

    # yang dipakai dibawah
    # diatas ndak tau, depreceate aja kalo aman

    def opd_test_indikator_program
      @jenis = 'program'
      @opd = Opd.find_by(kode_unik_opd: @kode_opd)
      @programs = @opd.program_renstra
      @program_kegiatans = Renstra::ProgramKegiatanRenstra.new(jenis: @jenis,
                                                               kode: 'program', tipe: 'program',
                                                               tahun: @tahun)
                                                          .indikator_programs_opd(opd: @opd, program_kegiatans_by_opd: @programs)
      respond_to { |f| f.json { render 'opd_test_indikator' } }
    end

    def opd_test_indikator_kegiatan
      @jenis = 'kegiatan'
      @opd = Opd.find_by(kode_unik_opd: @kode_opd)
      @programs = @opd.kegiatans_renstra
      @program_kegiatans = Renstra::ProgramKegiatanRenstra.new(jenis: @jenis,
                                                               kode: 'giat', tipe: 'kegiatan',
                                                               tahun: @tahun)
                                                          .indikator_programs_opd(opd: @opd, program_kegiatans_by_opd: @programs)
      respond_to { |f| f.json { render 'opd_test_indikator' } }
    end

    def opd_test_indikator_subkegiatan
      @jenis = 'subkegiatan'
      @opd = Opd.find_by(kode_unik_opd: @kode_opd)
      @programs = @opd.subkegiatans_renstra
      @program_kegiatans = Renstra::ProgramKegiatanRenstra.new(jenis: @jenis,
                                                               kode: 'sub_giat', tipe: 'subkegiatan',
                                                               tahun: @tahun)
                                                          .indikator_programs_opd(opd: @opd, program_kegiatans_by_opd: @programs)
      respond_to { |f| f.json { render 'opd_test_indikator' } }
    end

    # kota ( all opd )
    def kota_test_indikator_program
      @jenis = 'program'
      @program_kegiatans = Renstra::ProgramKegiatanRenstra.new(jenis: @jenis,
                                                               kode: 'program', tipe: 'program',
                                                               tahun: @tahun)
                                                          .program_kota(jenis_program_kegiatan: 'program_renstra')
      respond_to { |f| f.json { render 'kota_test_indikator' } }
    end

    def kota_test_indikator_kegiatan
      @jenis = 'kegiatan'
      @program_kegiatans = Renstra::ProgramKegiatanRenstra.new(jenis: @jenis,
                                                               kode: 'giat', tipe: 'kegiatan',
                                                               tahun: @tahun)
                                                          .program_kota(jenis_program_kegiatan: 'kegiatans_renstra')
      respond_to { |f| f.json { render 'kota_test_indikator' } }
    end

    def kota_test_indikator_subkegiatan
      @jenis = 'subkegiatan'
      @program_kegiatans = Renstra::ProgramKegiatanRenstra.new(jenis: @jenis,
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

    def kak_service
      @kak_service = KakService.new(kode_unik_opd: @kode_opd, tahun: @tahun)
    end
  end
end
