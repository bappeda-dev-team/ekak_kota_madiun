class RenstraController < ApplicationController
  before_action :set_renstra
  def index
    base_data = KakService.new(tahun: 2022, kode_unik_opd: @kode_unik_opd)
    @program_kegiatans = base_data.program_kegiatans_by_opd
  end

  def admin_renstra; end

  def edit
    @type = params[:type]
    @id = params[:id]
    @program = ProgramKegiatan.find(@id)
    @kode = @program.kode_sub_giat
    render partial: 'form_renstra'
  end

  def update_programs
    @program = ProgramKegiatan.find(params[:id])
    @tahun = params[:tahun]
    target = @program.target_subkegiatan_tahun(tahun: @tahun, kode_sub_giat: @program.kode_sub_giat)
    render plain: 'A good', status: :accepted if @program.update(renstra_params)
  end

  def set_renstra
    @kode_unik_opd = params[:kode_unik_opd]
    @tahun = params[:tahun]
  end

  private

  def renstra_params
    params.require(:program_kegiatan)
          .permit(:nama_subkegiatan, :tahun, :target_subkegiatan, :indikator_subkegiatan)
  end
end
