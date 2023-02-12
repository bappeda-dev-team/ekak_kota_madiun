class IsuStrategisKotaController < ApplicationController
  def index
    @isu_strategis = IsuStrategisKotum.all
  end

  def new
    @isu_strategis = IsuStrategisKotum.new
  end

  def edit
  end

  def create
    @isu_strategis = IsuStrategisKotum.new(isu_strategis_params)
    respond_to do |format|
      if @isu_strategis.save?
        format.html { redirect_to isu_strategis_kotum_path, success: "Isu Strategis Kota berhasil dibuat." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @isu_strategis.update(isu_strategis_params)
        format.html { redirect_to isu_strategis_kotum_path, success: "Isu Strategis Kota diupdate." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @isu_strategis.destroy
    respond_to do |format|
      format.html { redirect_to isu_strategis_kotum_path, success: "Isu Strategis Kota dihapus." }
    end
  end

  private

  def set_isu_strategis_kota
    @isu_strategis = IsuStrategisKotum.find(params[:id])
  end

  def isu_strategis_params
    params.require(:isu_strategis_kota).permit(:isu_strategis_kota, :kode, :tahun)
  end
end
