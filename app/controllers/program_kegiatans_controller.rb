class ProgramKegiatansController < ApplicationController
  before_action :set_programKegiatan, only: %i[ show edit update destroy show_to_kak ]
  before_action :set_dropdown, only: %i[ new edit ]
  layout false, only: %i[show_to_kak]

  def index
    @programKegiatans = ProgramKegiatan.all
  end

  def new
    @programKegiatan = ProgramKegiatan.new
  end

  def show
  end

  def show_to_kak
  end

  def edit
  end

  def create
    @programKegiatan = ProgramKegiatan.new(programKegiatan_params)
    respond_to do |format|
      if @programKegiatan.save
        format.html { redirect_to @programKegiatan, notice: "Program Kegiatan Dibuat" }
      else
        format.html { render :new, notice: "Gagal menyimpan Program Kegiatan" }
      end
    end
  end

  def update
    respond_to do |format|
      if @programKegiatan.update(programKegiatan_params)
        format.html { redirect_to @programKegiatan, notice: "Program Kegiatan diupdate" }
      else
        format.html { render :edit, notice: "Program Kegiatan Gagal diupdate" }
      end
    end
  end

  def destroy
    @programKegiatan.destroy
    respond_to do |format|
      format.html { redirect_to program_kegiatans_url, notice: "Program dihapus" }
    end
  end

  private

  def set_programKegiatan
    @programKegiatan = ProgramKegiatan.find(params[:id])
  end

  def set_dropdown
    @opds = Opd.all
  end

  def programKegiatan_params
    params.require(:program_kegiatan).permit!
  end
end
