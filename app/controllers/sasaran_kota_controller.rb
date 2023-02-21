class SasaranKotaController < ApplicationController
  before_action :set_sasaran_kota, only: %i[show edit update destroy]

  def index
    handle_filters
  end

  def show; end

  def new
    @sasaran_kota = SasaranKotum.new
    @tujuan_kota = TujuanKota.all
  end

  def edit; end

  def create
    @tujuan_kota = TujuanKota.find(sasaran_kota_params[:id_tujuan])
    updated_params = sasaran_kota_params.merge(tujuan: @tujuan_kota.tujuan)
    @sasaran_kota = @tujuan_kota.sasaran_kota.build(updated_params)

    respond_to do |format|
      if @sasaran_kota.save
        format.html { redirect_to sasaran_kota_path, success: 'Sasaran ditambahkan' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sasaran_kota.update(sasaran_kota_params)
        format.html { redirect_to sasaran_kota_path, success: 'Sukses' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sasaran_kota.destroy
    respond_to do |format|
      format.html { redirect_to sasaran_kota_path, success: 'Sasaran Kota dihapus' }
    end
  end

  def crosscutting_kota; end

  private

  def set_sasaran_kota
    @sasaran_kota = SasaranKotum.find(params[:id])
  end

  def sasaran_kota_params
    params.require(:sasaran_kotum).permit(:sasaran, :tahun_awal, :tahun_akhir, :id_tujuan)
  end

  def handle_filters
    tahun = params[:tahun]
    if tahun.nil? || tahun == 'all'
      @tahun = ''
      @sasaran_kota = SasaranKotum.all.includes([:indikator_sasarans])
    else
      @tahun = "Tahun #{tahun}"
      @sasaran_kota = SasaranKotum.where(tahun_awal: tahun).or(SasaranKotum.where(tahun_akhir: tahun)).includes([:indikator_sasarans])
    end
  end
end
