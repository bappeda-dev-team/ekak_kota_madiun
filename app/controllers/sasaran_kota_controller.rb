class SasaranKotaController < ApplicationController
  before_action :set_sasaran_kota, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  def index
    handle_filters
  end

  def show; end

  def new
    @strategi_kota = Tematik.find(params[:tematik_id]).id
    @sasaran_kota = SasaranKotum.new(tematik_id: @strategi_kota)
  end

  def edit; end

  def create
    @sasaran_kota = SasaranKotum.new(sasaran_kota_params)
    if @sasaran_kota.save
      strategi_kota = Tematik.find(sasaran_kota_params[:tematik_id])
      render json: { resText: 'Sasaran ditambahkan',
                     html_content: html_content({ sasaran: strategi_kota },
                                                partial: 'sasaran_kota/sasaran_kota') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ sasaran_kotum: @sasaran_kota },
                                                 partial: 'sasaran_kota/form') }.to_json,
             status: :unprocessable_entity
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
    params.require(:sasaran_kotum).permit(:sasaran, :tahun_awal, :tahun_akhir, :id_tujuan, :id_sasaran, :tematik_id,
                                          indikator_sasarans_params)
  end

  def indikator_sasarans_params
    { indikator_sasarans_attributes: %i[id kode jenis sub_jenis indikator target satuan tahun _destroy] }
  end

  def handle_filters
    tahun = params[:tahun]
    @tahun = if tahun.nil?
               cookies[:tahun]
             else
               "Tahun #{tahun}"
             end
    @sasaran_kota = Pohon.where(pohonable_type: %w[SubTematik SubSubTematik], tahun: @tahun).map(&:pohonable)
                         .compact
  end
end
