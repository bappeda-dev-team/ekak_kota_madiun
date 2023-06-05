class SpbesController < ApplicationController
  before_action :set_program, only: %i[edit new]
  before_action :set_spbe, only: %i[edit show update destroy]
  before_action :set_default_attr

  def index
    @spbes = Spbe.all.group_by(&:program_kegiatan)
  end

  def new
    @spbe = Spbe.new
    @sasaran_eselon3 = @program.program_sasaran(@tahun).map { |s| s.map_sasaran_atasan }.uniq
  end

  def edit
    @sasaran_eselon3 = @program.program_sasaran(@tahun).map { |s| s.map_sasaran_atasan }.uniq
  end

  def create
    @spbe = Spbe.new(spbe_params)

    respond_to do |format|
      if @spbe.save
        format.html { redirect_to spbe_laporans_path, notice: "Spbe dibuat" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_spbe
    @spbe = Spbe.find(params[:id])
  end

  def set_program
    @program = ProgramKegiatan.find(params[:program_id])
  end

  def set_default_attr
    @user = current_user
    @kode_opd = cookies[:opd]
    @tahun = cookies[:tahun] || Date.current.year
  end

  def spbe_params
    params.require(:spbe).permit(:jenis_pelayanan, :nama_aplikasi, :strategi_ref_id,
                                 :kode_program, :kode_opd, :program_kegiatan_id)
  end
end
