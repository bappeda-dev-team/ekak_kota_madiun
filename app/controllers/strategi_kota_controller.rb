class StrategiKotaController < ApplicationController
  before_action :set_strategi_kotum, only: %i[show edit update destroy]

  # GET /strategi_kota or /strategi_kota.json
  def index
    handle_filters
  end

  # GET /strategi_kota/1 or /strategi_kota/1.json
  def show; end

  # GET /strategi_kota/new
  def new
    @strategi_kotum = StrategiKotum.new
  end

  # GET /strategi_kota/1/edit
  def edit; end

  # POST /strategi_kota or /strategi_kota.json
  def create
    @strategi_kotum = StrategiKotum.new(strategi_kotum_params)

    respond_to do |format|
      if @strategi_kotum.save
        format.html { redirect_to strategi_kota_path, success: "Strategi Kota dibuat" }
        format.json { render :show, status: :created, location: @strategi_kotum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @strategi_kotum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /strategi_kota/1 or /strategi_kota/1.json
  def update
    respond_to do |format|
      if @strategi_kotum.update(strategi_kotum_params)
        format.html { redirect_to strategi_kota_path, success: "Update berhasil" }
        format.json { render :show, status: :ok, location: @strategi_kotum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @strategi_kotum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /strategi_kota/1 or /strategi_kota/1.json
  def destroy
    @strategi_kotum.destroy

    respond_to do |format|
      format.html { redirect_to strategi_kota_url, success: "Strategi Kota dihapus" }
      format.json { head :no_content }
    end
  end

  def bagikan_ke_opd
    @strategi_kota = StrategiKotum.find(params[:id])
    render partial: "form_bagikan_ke_opd"
  end

  def pilih_opd
    @strategi_kota = StrategiKotum.find(params[:id])
    @opd = Opd.find(params[:opd])
    respond_to do |format|
      if Usulan.create(usulanable_id: @strategi_kota.id, usulanable_type: 'StrategiKotum',
                       opd_id: @opd.id, keterangan: @opd.nama_opd)
        format.html { redirect_to strategi_kota_path, success: "dibagikan ke #{@opd.nama_opd}" }
      else
        format.html { redirect_to strategi_kota_path, status: :unprocessable_entity, alert: 'terjadi kesalahan' }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_strategi_kotum
    @strategi_kotum = StrategiKotum.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def strategi_kotum_params
    params.require(:strategi_kotum).permit(:strategi, :tahun, :sasaran_kota_id, :isu_strategis_kota_id)
  end

  def handle_filters
    tahun = params[:tahun]
    if tahun.nil? || tahun == 'all'
      @tahun = ''
      @strategi_kota = StrategiKotum.all
    else
      @tahun = "Tahun #{tahun}"
      @strategi_kota = StrategiKotum.where(tahun: tahun)
    end
  end
end
