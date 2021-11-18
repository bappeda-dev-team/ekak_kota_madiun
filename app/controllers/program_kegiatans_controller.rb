class ProgramKegiatansController < ApplicationController
  def index
  end

  def new
  end

  def show
  end

  def create
    programKegiatan = ProgramKegiatan.new(programKegiatan_params)
    if programKegiatan.save
      redirect_to "/programKegiatan/#{programKegiatan.id}"
    else
      render "Fail"
    end
  end


  private
  def programKegiatan_params
    params.require(:programKegiatan).permit!
  end

end
