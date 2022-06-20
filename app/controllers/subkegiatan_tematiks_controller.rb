class SubkegiatanTematiksController < ApplicationController
  before_action :set_subkegiatan_tematik, only: %i[show edit update destroy]

  # GET /subkegiatan_tematiks or /subkegiatan_tematiks.json
  def index
    @subkegiatan_tematiks = SubkegiatanTematik.all
  end

  def laporan_tematik; end

  def cetak_pdf
    kode_tematik = params[:id]
    @tematiks = Sasaran.sasaran_tematik(kode_tematik)
    @tahun = 2023
    @nama_file = SubkegiatanTematik.find_by(kode_tematik: @kode_tematik).nama_tematik
    @waktu = Time.now.strftime("%d_%m_%Y_%H_%M")
    @filename = "Laporan_Tematik_#{@nama_file}_#{@waktu}.pdf"
  end
  # GET /subkegiatan_tematiks/1 or /subkegiatan_tematiks/1.json
  def show; end

  # GET /subkegiatan_tematiks/new
  def new
    @subkegiatan_tematik = SubkegiatanTematik.new
  end

  # GET /subkegiatan_tematiks/1/edit
  def edit; end

  # POST /subkegiatan_tematiks or /subkegiatan_tematiks.json
  def create
    @subkegiatan_tematik = SubkegiatanTematik.new(subkegiatan_tematik_params)

    respond_to do |format|
      if @subkegiatan_tematik.save
        format.html { redirect_to @subkegiatan_tematik, notice: "Subkegiatan tematik was successfully created." }
        format.json { render :show, status: :created, location: @subkegiatan_tematik }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @subkegiatan_tematik.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subkegiatan_tematiks/1 or /subkegiatan_tematiks/1.json
  def update
    respond_to do |format|
      if @subkegiatan_tematik.update(subkegiatan_tematik_params)
        format.html { redirect_to @subkegiatan_tematik, notice: "Subkegiatan tematik was successfully updated." }
        format.json { render :show, status: :ok, location: @subkegiatan_tematik }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subkegiatan_tematik.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subkegiatan_tematiks/1 or /subkegiatan_tematiks/1.json
  def destroy
    @subkegiatan_tematik.destroy
    respond_to do |format|
      format.html { redirect_to subkegiatan_tematiks_url, notice: "Subkegiatan tematik was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subkegiatan_tematik
    @subkegiatan_tematik = SubkegiatanTematik.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def subkegiatan_tematik_params
    params.require(:subkegiatan_tematik).permit(:tahun, :nama_tematik, :kode_tematik)
  end
end
