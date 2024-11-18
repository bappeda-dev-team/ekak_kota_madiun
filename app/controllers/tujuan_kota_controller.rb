class TujuanKotaController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_tujuan_kota, only: %i[show edit update destroy]

  def index; end

  def admin_filter
    @tahun = cookies[:tahun]

    return if @tahun.nil?

    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_tahun(tahun_bener)
    @tahun_awal = @periode.tahun_awal.to_i
    @tahun_akhir = @periode.tahun_akhir.to_i

    @tujuan_kota = TujuanKota.all.includes([:indikator_tujuans])
                             .by_periode(tahun_bener)

    render partial: 'tujuan_kota/tujuan_kota'
  end

  def show; end

  def new
    @tahun = cookies[:tahun]
    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun

    @periode = Periode.find_tahun(tahun_bener)
    @tahun_awal = @periode.tahun_awal.to_i
    @tahun_akhir = @periode.tahun_akhir.to_i

    @tujuan_kota = TujuanKota.new
    @tujuan_kota.indikator_tujuans.build.targets.build

    render layout: false
  end

  def edit
    @tahun = cookies[:tahun]
    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_tahun(tahun_bener)
    @tahun_awal = @periode.tahun_awal.to_i
    @tahun_akhir = @periode.tahun_akhir.to_i
    render layout: false
  end

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
      format.html { redirect_to tujuan_kota_path, notice: 'Tujuan dihapus' }
      format.json { head :no_content }
    end
  end

  private

  def set_tujuan_kota
    @tujuan_kota = TujuanKota.find(params[:id])
  end

  def tujuan_kota_params
    params.require(:tujuan_kota).permit(:tujuan, :tahun_awal, :tahun_akhir, :id_tujuan, :kode_tujuan,
                                        :visi, :misi,
                                        indikator_tujuans_attributes)
  end

  def indikator_tujuans_attributes
    { indikator_tujuans_attributes: [:id, :kode, :kode_opd, :indikator, :rumus_perhitungan, :sumber_data, :_destroy,
                                     targets_attributes] }
  end

  def targets_attributes
    { targets_attributes: %i[id target satuan tahun indikator_id opd_id jenis _destroy] }
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
