class Master::ProgramController < ApplicationController

  def index
    @programs = Master::Program.all
  end

  def sync_master_program
    tahun = params[:tahun]
    request = Api::SipdMasterClient.new(tahun: tahun)
    request.sync_master_program
    redirect_to master_programs_path,
                success: "Update Master Program Selesai"
  end
end
