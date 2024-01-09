class IsuStrategisOpdsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_isu_strategis_opd, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /isu_strategis_opds or /isu_strategis_opds.json
  def index
    handle_filters
  end

  # GET /isu_strategis_opds/1 or /isu_strategis_opds/1.json
  def show; end

  # GET /isu_strategis_opds/new
  def new
    @tahun = cookies[:tahun].present? ? cookies[:tahun] : Date.today.year.to_s

    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_tahun(tahun_bener)
    @tahun_awal = @periode.tahun_awal.to_i
    @tahun_akhir = @periode.tahun_akhir.to_i

    kode_bidang_urusan = params[:kode_bidang_urusan]
    bidang_urusan = params[:bidang_urusan]
    opd = params[:opd]
    @isu_strategis_opd = IsuStrategisOpd.new(bidang_urusan: bidang_urusan,
                                             kode_bidang_urusan: kode_bidang_urusan,
                                             kode_opd: opd, tahun: @tahun)
    @isu_strategis_opd.permasalahan_opds.build
  end

  # GET /isu_strategis_opds/1/edit
  def edit
    @tahun = cookies[:tahun].present? ? cookies[:tahun] : Date.today.year.to_s
    @kode_opd = cookies[:opd]

    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_tahun(tahun_bener)
    @tahun_awal = @periode.tahun_awal.to_i
    @tahun_akhir = @periode.tahun_akhir.to_i
  end

  # POST /isu_strategis_opds or /isu_strategis_opds.json
  def create
    @isu_strategis_opd = IsuStrategisOpd.new(isu_strategis_opd_params)
    if @isu_strategis_opd.save
      render json: { resText: "Sukses" }.to_json,
             status: :created
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /isu_strategis_opds/1 or /isu_strategis_opds/1.json
  def update
    if @isu_strategis_opd.update(isu_strategis_opd_params)
      render json: { resText: "Sukses" }.to_json,
             status: :ok
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /isu_strategis_opds/1 or /isu_strategis_opds/1.json
  def destroy
    @isu_strategis_opd.destroy

    render json: { resText: "Isu Strategis Dihapus", result: true },
           status: :accepted
  end

  def admin_filter
    @kode_opd = params[:kode_opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    tahun = params[:tahun]
    tahun_tanpa_perubahan = tahun.gsub('_perubahan', '')
    @tahun = "Tahun #{tahun}"
    @isu_strategis_opds = @opd.isu_strategis_opds.where(tahun: [tahun, tahun_tanpa_perubahan])
    render partial: 'isu_strategis_opds/isu_strategis_opd'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_isu_strategis_opd
    @isu_strategis_opd = IsuStrategisOpd.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def isu_strategis_opd_params
    params.require(:isu_strategis_opd).permit(:kode, :bidang_urusan, :kode_bidang_urusan, :isu_strategis, :tahun,
                                              :kode_opd, :tujuan, permasalahan_opds_attributes)
  end

  def permasalahan_opds_attributes
    { permasalahan_opds_attributes: [:id, :kode_opd, :permasalahan,
                                     :faktor_penghambat_skp, :_destroy,
                                     data_dukung_attributes] }
  end

  def data_dukung_attributes
    { data_dukungs_attributes: %i[id data_dukungable_type data_dukungable_id nama_data jumlah satuan tahun _destroy] }
  end

  def opd_pemilik
    @opd = Opd.find_by(kode_opd: params[:kode_opd])
  end

  def handle_filters
    tahun = params[:tahun]
    kode_opd = params[:kode_opd]
    @opd = kode_opd.blank? ? current_user.opd : Opd.find_by(kode_unik_opd: kode_opd)
    @nama_opd = @opd.nama_opd
    if tahun.nil? || tahun == 'all'
      @tahun = ''
      @isu_strategis_opds = @opd.isu_strategis_opds
    else
      @tahun = "Tahun #{tahun}"
      @isu_strategis_opds = @opd.isu_strategis_opds.where(tahun: tahun)
    end
  end
end
