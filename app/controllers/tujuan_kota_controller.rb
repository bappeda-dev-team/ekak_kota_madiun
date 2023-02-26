class TujuanKotaController < ApplicationController
  before_action :set_tujuan_kota, only: %i[show edit update destroy]

  def index
    handle_filters
  end

  def show; end

  def new
    @tujuan_kota = TujuanKota.new
  end

  def edit; end

  def create
    @tujuan_kota = TujuanKota.new(tujuan_kota_params)

    respond_to do |format|
      if @tujuan_kota.save
        format.html { redirect_to tujuan_kota_path, success: 'Tujuan ditambahkan' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tujuan_kota.update(tujuan_kota_params)
        format.html { redirect_to tujuan_kota_path, success: 'Tujuan diupdate' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tujuan_kota.destroy
    respond_to do |format|
      format.html { redirect_to tujuan_kota_path, success: 'Tujuan dihapus' }
    end
  end

  private

  def set_tujuan_kota
    @tujuan_kota = TujuanKota.find(params[:id])
  end

  def tujuan_kota_params
    params.require(:tujuan_kota).permit(:tujuan, :tahun_awal, :tahun_akhir, :id_tujuan, indikator_tujuans_attributes)
  end

  def indikator_tujuans_attributes
    { indikator_tujuans_attributes: %i[id kode jenis sub_jenis indikator target satuan tahun _destroy] }
  end

  def handle_filters
    tahun = params[:tahun]
    if tahun.nil? || tahun == 'all'
      @tahun = ''
      @tujuan_kota = TujuanKota.all.includes([:indikator_tujuans])
    else
      @tujuan_kota = TujuanKota.where(tahun_awal: tahun).or(TujuanKota.where(tahun_akhir: tahun)).includes([:indikator_tujuans])
      @tahun = "Tahun #{tahun}"
    end
  end
end
