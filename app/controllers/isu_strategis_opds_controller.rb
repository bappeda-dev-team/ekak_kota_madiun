class IsuStrategisOpdsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_isu_strategis_opd, only: %i[show edit update destroy]

  # GET /isu_strategis_opds or /isu_strategis_opds.json
  def index
    handle_filters
  end

  # GET /isu_strategis_opds/1 or /isu_strategis_opds/1.json
  def show; end

  # GET /isu_strategis_opds/new
  def new
    opd_collections
    @isu_strategis_opd = IsuStrategisOpd.new
  end

  # GET /isu_strategis_opds/1/edit
  def edit
    opd_collections
  end

  # POST /isu_strategis_opds or /isu_strategis_opds.json
  def create
    @isu_strategis_opd = IsuStrategisOpd.new(isu_strategis_opd_params)

    respond_to do |format|
      if @isu_strategis_opd.save
        format.html do
          redirect_to isu_strategis_opds_url, success: "Sukses"
        end
        format.json { render :show, status: :created, location: @isu_strategis_opd }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @isu_strategis_opd.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /isu_strategis_opds/1 or /isu_strategis_opds/1.json
  def update
    respond_to do |format|
      if @isu_strategis_opd.update(isu_strategis_opd_params)
        format.html do
          redirect_to isu_strategis_opds_url, success: "Sukses"
        end
        format.json { render :show, status: :ok, location: @isu_strategis_opd }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @isu_strategis_opd.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /isu_strategis_opds/1 or /isu_strategis_opds/1.json
  def destroy
    @isu_strategis_opd.destroy

    respond_to do |format|
      format.html { redirect_to isu_strategis_opds_url, success: "Isu strategis dihapus" }
      format.json { head :no_content }
    end
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
    params.require(:isu_strategis_opd).permit(:kode, :isu_strategis, :tahun, :kode_opd, :tujuan)
  end

  def opd_pemilik
    @opd = Opd.find_by(kode_opd: params[:kode_opd])
  end

  def opd_collections
    @opds = Opd.where.not(kode_opd: nil)
               .where(kode_opd: current_user.kode_opd).pluck(:nama_opd,
                                                             :kode_opd)
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
