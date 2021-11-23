class ProgramKegiatansController < ApplicationController
  def index
    @programKegiatan = ProgramKegiatan.all
  end

  def new
    @programKegiatan = ProgramKegiatan.new
  end

  def show
  end

  def create
    @programKegiatan = ProgramKegiatan.new(program_kegiatan_params)
    respond_to do |format|
      if @programKegiatan.save
        format.html { redirect_to @programKegiatan, notice: "User was successfully created." }
      else
        format.html { render :new, notice: "Failed create user" }
      end
    end
  end


  private
  def program_kegiatan_params
    params.require(:program_kegiatan).permit!
  end

end
