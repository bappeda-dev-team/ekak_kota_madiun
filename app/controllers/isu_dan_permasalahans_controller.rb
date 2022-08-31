class IsuDanPermasalahansController < ApplicationController
  before_action :set_params

  def index; end

  def filter_isu
    programs = KakService.new(tahun: @tahun, kode_unik_opd: @kode_unik_opd).program_kegiatans_by_opd
    @program_kegiatans = programs
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
    render plain: @isu_strategis, status: :accepted if program
  end

  private

  def set_params
    @kode_unik_opd = params[:kode_unik_opd]
    @tahun = params[:tahun]
  end

  def isu_strategis_params
    params.require(:program_kegiatan).permit(:isu_strategis, :kode_program, :nama_program)
  end
end
