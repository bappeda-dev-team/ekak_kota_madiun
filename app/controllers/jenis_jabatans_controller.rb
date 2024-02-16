class JenisJabatansController < ApplicationController
  before_action :set_jenis_jabatan, only: %i[ show edit update destroy ]

  # GET /jenis_jabatans or /jenis_jabatans.json
  def index
    @jenis_jabatans = JenisJabatan.all
  end

  # GET /jenis_jabatans/1 or /jenis_jabatans/1.json
  def show
  end

  # GET /jenis_jabatans/new
  def new
    @jenis_jabatan = JenisJabatan.new
  end

  # GET /jenis_jabatans/1/edit
  def edit
  end

  # POST /jenis_jabatans or /jenis_jabatans.json
  def create
    @jenis_jabatan = JenisJabatan.new(jenis_jabatan_params)

    respond_to do |format|
      if @jenis_jabatan.save
        format.html { redirect_to jenis_jabatan_url(@jenis_jabatan), notice: "Jenis jabatan was successfully created." }
        format.json { render :show, status: :created, location: @jenis_jabatan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @jenis_jabatan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jenis_jabatans/1 or /jenis_jabatans/1.json
  def update
    respond_to do |format|
      if @jenis_jabatan.update(jenis_jabatan_params)
        format.html { redirect_to jenis_jabatan_url(@jenis_jabatan), notice: "Jenis jabatan was successfully updated." }
        format.json { render :show, status: :ok, location: @jenis_jabatan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @jenis_jabatan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jenis_jabatans/1 or /jenis_jabatans/1.json
  def destroy
    @jenis_jabatan.destroy

    respond_to do |format|
      format.html { redirect_to jenis_jabatans_url, notice: "Jenis jabatan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jenis_jabatan
      @jenis_jabatan = JenisJabatan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jenis_jabatan_params
      params.require(:jenis_jabatan).permit(:nama_jenis, :nilai, :keterangan, :tahun)
    end
end
