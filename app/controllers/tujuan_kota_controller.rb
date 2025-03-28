class TujuanKotaController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_tujuan_kota, only: %i[show edit update destroy]

  # see admin_filter for ajax
  def index
    @tahun = cookies[:tahun]
    return if @tahun.nil?

    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_tahun(tahun_bener)
    @tahun_awal = @periode.tahun_awal.to_i
    @tahun_akhir = @periode.tahun_akhir.to_i
  end

  def list_tujuan
    @tahun = cookies[:tahun]
    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_tahun(tahun_bener)
    @tahun_awal = @periode.tahun_awal.to_i
    @tahun_akhir = @periode.tahun_akhir.to_i

    @tujuan_kota = TujuanKota.all.includes([:indikator_tujuans])
                             .by_periode(tahun_bener)
  end

  def admin_filter
    @tahun = cookies[:tahun]
    periode_selected = params[:periode]

    return if @tahun.nil?

    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = if periode_selected.present?
                 Periode.find(periode_selected)
               else
                 Periode.find_tahun(tahun_bener)
               end
    @tahun_awal = @periode.tahun_awal.to_i
    @tahun_akhir = @periode.tahun_akhir.to_i

    @tujuan_kota = TujuanKota.all.includes([:indikator_tujuans])
                             .by_tahun_awal_akhir(@tahun_awal, @tahun_akhir)
                             .order(:id)

    render partial: 'tujuan_kota/tujuan_kota'
  end

  def show; end

  def new
    @tahun = cookies[:tahun]
    # tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun

    # @periode = Periode.find_tahun(tahun_bener)
    # @tahun_awal = @periode.tahun_awal.to_i
    # @tahun_akhir = @periode.tahun_akhir.to_i

    @tujuan_kota = TujuanKota.new
    @tujuan_kota.indikator_tujuans.build.targets.build

    render layout: false
  end

  def edit
    @tahun = cookies[:tahun]
    # tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_by(tahun_awal: @tujuan_kota.tahun_awal,
                               tahun_akhir: @tujuan_kota.tahun_akhir)
    # @tahun_awal = @periode.tahun_awal.to_i
    # @tahun_akhir = @periode.tahun_akhir.to_i
    render layout: false
  end

  def create
    @tujuan_kota = TujuanKota.new(tujuan_kota_params)
    @tahun_awal = tujuan_kota_params[:tahun_awal]
    @tahun_akhir = tujuan_kota_params[:tahun_akhir]

    if @tujuan_kota.save
      render json: { html_content: html_content({ tujuan_kota: @tujuan_kota },
                                                partial: 'tujuan_kota/tujuan_kota_row') }
        .to_json, status: :ok
    else
      render json: { html_content: html_content({ tujuan_kota: @tujuan_kota },
                                                partial: 'tujuan_kota/form') }
        .to_json, status: :unprocessable_entity
    end
  end

  def update
    # @tahun = cookies[:tahun]
    # tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    # @periode = Periode.find_tahun(tahun_bener)
    # @tahun_awal = @periode.tahun_awal.to_i
    # @tahun_akhir = @periode.tahun_akhir.to_i
    @tahun_awal = tujuan_kota_params[:tahun_awal]
    @tahun_akhir = tujuan_kota_params[:tahun_akhir]

    if @tujuan_kota.update(tujuan_kota_params)
      render json: { html_content: html_content({ tujuan_kota: @tujuan_kota },
                                                partial: 'tujuan_kota/tujuan_kota_row') }
        .to_json, status: :ok
    else
      render json: { html_content: html_content({ tujuan_kota: @tujuan_kota },
                                                partial: 'tujuan_kota/form') }
        .to_json, status: :unprocessable_entity
    end
  end

  def destroy
    @tujuan_kota.destroy

    render json: { resText: "Tujuan Kota Dihapus" }.to_json, status: :accepted
  end

  def target_indikator_fields
    @tahun_awal = params[:tahun_awal]
    @tahun_akhir = params[:tahun_akhir]
    @indikator_id = params[:indikator_id]
    @index = params[:index_form]

    render partial: 'tujuan_kota/target_indikator'
  end

  private

  def set_tujuan_kota
    @tujuan_kota = TujuanKota.find(params[:id])
  end

  def tujuan_kota_params
    params.require(:tujuan_kota).permit(:tujuan, :tahun_awal, :tahun_akhir, :id_tujuan, :kode_tujuan,
                                        :visi_id, :misi_id, :pohon_id,
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
