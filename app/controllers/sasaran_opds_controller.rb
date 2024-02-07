class SasaranOpdsController < ApplicationController
  before_action :set_sasaran_opd, only: %i[show edit update destroy]

  # GET /sasaran_opds or /sasaran_opds.json
  def index
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @user = @opd.eselon_dua_opd
    @sasaran_opds = @user.sasaran_pohon_kinerja(tahun: @tahun)
  end

  # GET /sasaran_opds/1 or /sasaran_opds/1.json
  def show; end

  # GET /sasaran_opds/new
  def new
    @sasaran_opd = SasaranOpd.new
  end

  # GET /sasaran_opds/1/edit
  def edit; end

  # POST /sasaran_opds or /sasaran_opds.json
  def create
    @sasaran_opd = SasaranOpd.new(sasaran_opd_params)

    respond_to do |format|
      if @sasaran_opd.save
        format.html { redirect_to sasaran_opds_url, notice: "Sukses" }
        format.json { render :show, status: :created, location: @sasaran_opd }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sasaran_opd.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sasaran_opds/1 or /sasaran_opds/1.json
  def update
    respond_to do |format|
      if @sasaran_opd.update(sasaran_opd_params)
        format.html { redirect_to sasaran_opds_url, notice: "Sukses" }
        format.json { render :show, status: :ok, location: @sasaran_opd }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sasaran_opd.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sasaran_opds/1 or /sasaran_opds/1.json
  def destroy
    @sasaran_opd.destroy

    respond_to do |format|
      format.html { redirect_to sasaran_opds_url, notice: "Sasaran opd dihapus" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sasaran_opd
    @sasaran_opd = SasaranOpd.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def sasaran_opd_params
    params.require(:sasaran_opd).permit(:sasaran, :id_sasaran, :kode_unik_opd, :tahun_awal, :tahun_akhir, :sasaran_opd,
                                        indikators_attributes)
  end

  def indikators_attributes
    { indikators_attributes: %i[id kode kode_opd indikator target satuan tahun _destroy] }
  end
end
