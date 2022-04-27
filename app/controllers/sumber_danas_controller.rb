class SumberDanasController < ApplicationController

  def index
    @sumber_danas = SumberDana.all
  end

  def new
    @sumber_dana = SumberDana.new
  end

  def edit
    @sumber_dana = SumberDana.find(params[:id])
    render :new
  end

  def create
    @sumber_danas = SumberDana.create(sumber_dana_params)
    if @sumber_danas.save
      render 'shared/_notifier_v2', locals: { message: 'sumber dana dibuat', status_icon: 'success', form_name: 'form-sumberdana' }
    else
      render 'shared/_notifier_v2', locals: { message: 'isian belum terisi', status_icon: 'error' }, status: :unprocessable_entity
    end
  end

  def update
    @sumber_dana = SumberDana.find(params[:id])
    if @sumber_dana.update(sumber_dana_params)
      render 'shared/_notifier_v2', locals: { message: 'sumber dana diupdate', status_icon: 'success', form_name: 'form-sumberdana' }
    else
      render 'shared/_notifier_v2', locals: { message: 'isian belum terisi', status_icon: 'error' }, status: :unprocessable_entity
    end
  end

  def destroy
    @sumber_dana = SumberDana.find(params[:id])
    @sumber_dana.destroy
    respond_to do |format|
      format.html { redirect_to sumber_danas_url, success: "Sumber Dana Dihapus" }
      format.json { head :no_content }
    end
  end

  private

  def sumber_dana_params
    params.require(:sumber_dana).permit(:kode_sumber_dana, :sumber_dana, :tahun)
  end
end