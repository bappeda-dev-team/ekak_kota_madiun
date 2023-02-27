class IsuStrategisKotaController < ApplicationController
  before_action :set_isu_strategis_kota, only: %i[ show edit update destroy ]

  def index
    handle_filters
  end

  def new
    @isu_strategis = IsuStrategisKotum.new
  end

  def edit
  end

  def create
    @isu_strategis = IsuStrategisKotum.new(isu_strategis_params)
    respond_to do |format|
      if @isu_strategis.save
        format.html { redirect_to isu_strategis_kota_path, success: "Isu Strategis Kota berhasil dibuat." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @isu_strategis.update(isu_strategis_params)
        format.html { redirect_to isu_strategis_kota_path, success: "Isu Strategis Kota diupdate." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @isu_strategis.destroy
    respond_to do |format|
      format.html { redirect_to isu_strategis_kota_path, success: "Isu Strategis Kota dihapus." }
    end
  end

  def list_strategi_kota
    @isu_strategis_kota = IsuStrategisKotum.find(params[:id])&.strategi_kotums
    render partial: 'list_strategi_kota'
  end

  private

  def set_isu_strategis_kota
    @isu_strategis = IsuStrategisKotum.find(params[:id])
  end

  def isu_strategis_params
    params.require(:isu_strategis_kotum).permit(:isu_strategis, :kode, :tahun)
  end

  def tahun_default
    @tahun_default = cookies[:tahun_sasaran] || Date.today.year
  end

  # find way to refactor this to global method
  def handle_filters
    tahun = params[:tahun]
    if tahun.nil? || tahun == 'all'
      @tahun = ''
      @isu_strategis_kota = IsuStrategisKotum.all
    else
      @tahun = "Tahun #{tahun}"
      @isu_strategis_kota = IsuStrategisKotum.where(tahun: tahun)
    end
  end
end
