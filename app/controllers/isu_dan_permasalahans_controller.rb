class IsuDanPermasalahansController < ApplicationController
  before_action :set_params
  layout false, only: :filter

  def index; end

  def filter
    @opd = Opd.find_by(kode_unik_opd: @kode_unik_opd)
    @nama_opd = @opd.nama_opd
    tahun_asli = @tahun.include?('perubahan') ? @tahun.gsub('_perubahan', '') : @tahun
    @isu_strategis = @opd.isu_strategis_opds
                         .where("tahun ILIKE ?", "%#{tahun_asli}%")
                         .order(:id).group_by { |isu| "(#{isu.kode_bidang_urusan}) #{isu.bidang_urusan}" }
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
    @kode_unik_opd = params[:kode_opd]
    @tahun = params[:tahun]
  end

  def isu_strategis_params
    params.require(:program_kegiatan).permit(:isu_strategis, :kode_program, :nama_program)
  end
end
