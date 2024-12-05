class InovasiMasyarakatsController < ApplicationController
  before_action :set_inovasi_masyarakat, only: %i[ show edit update destroy ]

  # GET /inovasi_masyarakats or /inovasi_masyarakats.json
  def index
    @inovasi_masyarakats = InovasiMasyarakat.all
  end

  # GET /inovasi_masyarakats/1 or /inovasi_masyarakats/1.json
  def show
  end

  # GET /inovasi_masyarakats/new
  def new
    @inovasi_masyarakat = InovasiMasyarakat.new
  end

  # GET /inovasi_masyarakats/1/edit
  def edit
  end

  # POST /inovasi_masyarakats or /inovasi_masyarakats.json
  def create
    @inovasi_masyarakat = InovasiMasyarakat.new(inovasi_masyarakat_params)

    respond_to do |format|
      if @inovasi_masyarakat.save
        format.html { redirect_to inovasi_masyarakat_url(@inovasi_masyarakat), notice: "Inovasi masyarakat was successfully created." }
        format.json { render :show, status: :created, location: @inovasi_masyarakat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inovasi_masyarakat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inovasi_masyarakats/1 or /inovasi_masyarakats/1.json
  def update
    respond_to do |format|
      if @inovasi_masyarakat.update(inovasi_masyarakat_params)
        format.html { redirect_to inovasi_masyarakat_url(@inovasi_masyarakat), notice: "Inovasi masyarakat was successfully updated." }
        format.json { render :show, status: :ok, location: @inovasi_masyarakat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inovasi_masyarakat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inovasi_masyarakats/1 or /inovasi_masyarakats/1.json
  def destroy
    @inovasi_masyarakat.destroy

    respond_to do |format|
      format.html { redirect_to inovasi_masyarakats_url, notice: "Inovasi masyarakat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inovasi_masyarakat
      @inovasi_masyarakat = InovasiMasyarakat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def inovasi_masyarakat_params
      params.require(:inovasi_masyarakat).permit(:nama_pelapor, :no_whatsapp, :alamat, :email_pelapor, :inovasi, :gambaran_nilai_kebaruan, :status_laporan, :keterangan, :metadata, :id_tiket)
    end
end
