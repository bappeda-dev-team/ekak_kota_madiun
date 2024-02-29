class AnggaranSbksController < ApplicationController
  before_action :set_anggaran_sbk, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /anggaran_sbks or /anggaran_sbks.json
  def index
    @anggaran_sbks = if current_user.id == 1
                       AnggaranSbk.all.limit(50)
                     else
                       AnggaranSbk.where(opd_id: current_user.opd.id)
                     end
  end

  # GET /anggaran_sbks/1 or /anggaran_sbks/1.json
  def show; end

  # GET /anggaran_sbks/new
  def new
    @anggaran_sbk = AnggaranSbk.new
  end

  # GET /anggaran_sbks/1/edit
  def edit; end

  # POST /anggaran_sbks or /anggaran_sbks.json
  def create
    @anggaran_sbk = AnggaranSbk.new(anggaran_sbk_params)

    respond_to do |format|
      if @anggaran_sbk.save
        format.html { redirect_to anggaran_sbks_path, notice: "Anggaran sbk was successfully created." }
        format.json { render :show, status: :created, location: @anggaran_sbk }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @anggaran_sbk.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /anggaran_sbks/1 or /anggaran_sbks/1.json
  def update
    respond_to do |format|
      if @anggaran_sbk.update(anggaran_sbk_params)
        format.html { redirect_to anggaran_sbks_path, notice: "Anggaran sbk was successfully updated." }
        format.json { render :show, status: :ok, location: @anggaran_sbk }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @anggaran_sbk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anggaran_sbks/1 or /anggaran_sbks/1.json
  def destroy
    @anggaran_sbk.destroy

    respond_to do |format|
      format.html { redirect_to anggaran_sbks_url, notice: "Anggaran sbk was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_anggaran_sbk
    @anggaran_sbk = AnggaranSbk.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def anggaran_sbk_params
    params.require(:anggaran_sbk).permit(:harga_satuan, :id_standar_harga, :kode_barang, :kode_kelompok_barang,
                                         :satuan, :spesifikasi, :tahun, :uraian_barang, :uraian_kelompok_barang, :opd_id)
  end
end
