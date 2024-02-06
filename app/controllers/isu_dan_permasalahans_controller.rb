class IsuDanPermasalahansController < ApplicationController
  before_action :set_params

  def index
    isu_dan_permasalahan = IsuDanPermasalahan.new(tahun: @tahun, kode_opd: @kode_unik_opd)
    @opd = isu_dan_permasalahan.opd
    @list_bidang_urusans = isu_dan_permasalahan.list_bidang_urusans
    @isu_strategis = isu_dan_permasalahan.isu_strategis

    # TODO: hard-coded
    tahun_awal = 2019
    tahun_akhir = 2023
    @range_tahun = tahun_akhir.downto(tahun_awal).to_a
  end

  def add_new
    @kode_program = params[:kode_program]
    @program_kegiatan = ProgramKegiatan.find(@kode_program)
    render partial: 'form_isu_strategis'
  end

  def add_isu_strategis
    isu_params = isu_strategis_params
    @tahun = params[:tahun]
    program = ProgramKegiatan.where(kode_program: isu_strategis_params[:kode_program])
                             .update_all(isu_params.to_h)
    @isu_strategis = ProgramKegiatan.find(params[:kode_program]).isu_strategis
    render json: { resText: 'Isu Strategis disimpan', result: @isu_strategis }, status: :accepted if program
  end

  private

  def set_params
    @kode_unik_opd = cookies[:opd]
    @tahun = cookies[:tahun]
  end

  def isu_strategis_params
    params.require(:program_kegiatan).permit(:isu_strategis, :kode_program, :nama_program)
  end
end
