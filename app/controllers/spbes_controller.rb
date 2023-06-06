class SpbesController < ApplicationController
  before_action :set_program, only: %i[edit new]
  before_action :set_spbe, only: %i[edit show update destroy]
  before_action :set_default_attr

  def index
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @spbes = Spbe.all.group_by(&:program_kegiatan)
  end

  def new
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @spbe = Spbe.new
    @sasaran_eselon3 = @program.program_sasaran(@tahun).map(&:map_sasaran_atasan).uniq
    @sasaran_kinerja = @sasaran_eselon3.map { |s| s.strategi.operational_objectives.map(&:sasaran) }.flatten.uniq
  end

  def edit
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @sasaran_eselon3 = @program.program_sasaran(@tahun).map(&:map_sasaran_atasan).uniq
    @sasaran_kinerja = @sasaran_eselon3.map { |s| s.strategi.operational_objectives.map(&:sasaran) }.flatten.uniq
  end

  def create
    @spbe = Spbe.new(spbe_params)

    respond_to do |format|
      if @spbe.save
        format.html { redirect_to spbes_path, notice: "Sukses Mengentri SPBE Baru" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @spbe.update(spbe_params)
        format.html { redirect_to spbes_path, notice: "Entri SPBE Diperbarui" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    jenis_pelayanan = @spbe.jenis_pelayanan
    @spbe.destroy
    respond_to do |format|
      format.html { redirect_to spbes_path, success: "Entri SPBE '#{jenis_pelayanan}' Dihapus" }
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
    params.require(:spbe).permit(:jenis_pelayanan, :nama_aplikasi,
                                 :strategi_ref_id, :kode_program,
                                 :kode_opd, :program_kegiatan_id,
                                 spbe_rincians_params)
  end

  def spbe_rincians_params
    { spbe_rincians_attributes: %i[id detail_kebutuhan detail_sasaran_kinerja
                                   keterangan id_rencana kebutuhan_spbe
                                   kode_opd kode_program _destroy] }
  end
end
