class RenstraController < ApplicationController
  before_action :set_renstra

  def index
    base_data = KakService.new(tahun: 2022, kode_unik_opd: @kode_unik_opd)
    @program_kegiatans = base_data.program_kegiatans_by_opd
  end

  def admin_renstra; end

  def edit
    @nama = params[:nama]
    @indikator = params[:indikator]
    @kode = params[:kode]
    @satuan = params[:satuan]
    @jenis = params[:jenis]
    @sub_jenis = params[:sub_jenis]
    @id = params[:id]
    @program = ProgramKegiatan.find(@id)
    @targets = @program.send("target_#{@sub_jenis.downcase}_renstra")
    render partial: 'form_renstra'
  end

  def update_programs
    param_indikator = indikator_params.to_h
    @indikator = param_indikator[:indikator]
    indikator = Indikator.insert_all(@indikator, returning: %w[indikator])
    render plain: 'A good', status: :accepted if indikator
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

  def indikator_params
    params.require(:renstra).permit(indikator: %i[indikator tahun satuan kode jenis sub_jenis target])
  end
end
