module Api
  class ProgramsController < ApplicationController
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!

    OPD_TABLE = {
      'Dinas Kesehatan, Pengendalian Penduduk dan Keluarga Berencana': "Dinas Kesehatan",
      'Rumah Sakit Umum Daerah Kota Madiun': "Rumah Sakit Umum Daerah",
      'Sekretariat Daerah': "Sekretaris Daerah",
      'Bagian Umum': "Bagian Umum",
      'Bagian Pengadaan Barang/Jasa dan Administrasi Pembangunan': "Bagian Pengadaan Barang/Jasa dan Administrasi Pembangunan",
      'Bagian Organisasi': "Bagian Organisasi",
      'Bagian Hukum': "Bagian Hukum",
      'Bagian Perekonomian dan Kesejahteraan Rakyat': "Bagian Perekonomian dan Kesejahteraan Rakyat",
      'Bagian Pemerintahan': "Bagian Pemerintahan"
    }.freeze

    KODE_OPD_BAGIAN = {
      'Dinas Kesehatan, Pengendalian Penduduk dan Keluarga Berencana': "448",
      'Rumah Sakit Umum Daerah Kota Madiun': "3408",
      'Sekretariat Daerah': "479", # don't change, this still used
      'Bagian Umum': "4402",
      'Bagian Pengadaan Barang/Jasa dan Administrasi Pembangunan': "4400",
      'Bagian Organisasi': "4398",
      'Bagian Hukum': "4399",
      'Bagian Perekonomian dan Kesejahteraan Rakyat': "4401",
      'Bagian Pemerintahan': "4397"
    }.freeze

    def indikators
      @kode_opd = params[:kode_opd]
      opd = Opd.find_by(kode_unik_opd: @kode_opd).nama_opd
      @programKegiatans = ProgramKegiatan.includes(:opd)
                                         .select("DISTINCT ON(program_kegiatans.kode_program) program_kegiatans.*")
                                         .where(opds: { kode_unik_opd: @kode_opd }).where(kode_program: kode_program)
      if OPD_TABLE.key?(opd.to_sym)
        @programKegiatans = ProgramKegiatan.includes(:opd)
                                           .select("DISTINCT ON(program_kegiatans.kode_program) program_kegiatans.*")
                                           .where(id_sub_unit: KODE_OPD_BAGIAN[opd.to_sym])
                                           .where(kode_program: kode_program)
      end
      respond_to do |format|
        @render_file = "program_kegiatans/hasil_filter_program"
        format.json { render 'program_kegiatans/filter_program' }
      end
    end

    def permasalahans
      @kode_opd = params[:kode_opd]
      @tahun = 2022
      @program_kegiatans = KakService.new(kode_unik_opd: @kode_opd, tahun: @tahun).isu_strategis
      respond_to do |format|
        format.json { render 'program_kegiatans/permasalahans' }
      end
    end

    def kode_program
      params[:kode_program]
    end

    def bidang_checker(nama_opd)
      OPD_TABLE.values_at(nama_opd.to_sym)
    end
  end
end
