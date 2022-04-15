class ProgramsController < ApplicationController
  
  def index
    tahun = params[:tahun]
    @programs = Program.all
  end

  def program_opd
    # WARNING no method error
    @programs = Opd.programs
  end

  def create
    @program = Program.create(program_params)
    respond_to do |format|
      if @program.save
        format.html { redirect_to programs_path, notice: 'Program berhasil ditambahkan.' }
      else
        format.js { :unprocessable_entity }
      end
    end
  end

  def update
    @program = Program.update(program_params)
    respond_to do |format|
      if @program.update
        format.html { redirect_to programs_path, notice: 'Program berhasil diupdate.' }
      else
        format.js { :unprocessable_entity }
      end
    end
  end

  private

  def program_params
    params.require(:program).permit!
  end
end
