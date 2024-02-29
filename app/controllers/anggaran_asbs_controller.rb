class AnggaranAsbsController < ApplicationController
  before_action :set_anggaran_asb, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /anggaran_asbs or /anggaran_asbs.json
  def index
    @anggaran_asbs = if current_user.id == 1
                       AnggaranAsb.all.limit(50)
                     else
                       AnggaranAsb.where(opd_id: current_user.opd.id)
                     end
  end

  # GET /anggaran_asbs/1 or /anggaran_asbs/1.json
  def show; end

  # GET /anggaran_asbs/new
  def new
    @anggaran_asb = AnggaranAsb.new
  end

  # GET /anggaran_asbs/1/edit
  def edit; end

  # POST /anggaran_asbs or /anggaran_asbs.json
  def create
    @anggaran_asb = AnggaranAsb.new(anggaran_asb_params)

    respond_to do |format|
      if @anggaran_asb.save
        format.html { redirect_to anggaran_asbs_path, notice: "Anggaran asb was successfully created." }
        format.json { render :show, status: :created, location: @anggaran_asb }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @anggaran_asb.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /anggaran_asbs/1 or /anggaran_asbs/1.json
  def update
    respond_to do |format|
      if @anggaran_asb.update(anggaran_asb_params)
        format.html { redirect_to anggaran_asbs_path, notice: "Anggaran asb was successfully updated." }
        format.json { render :show, status: :ok, location: @anggaran_asb }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @anggaran_asb.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anggaran_asbs/1 or /anggaran_asbs/1.json
  def destroy
    @anggaran_asb.destroy

    respond_to do |format|
      format.html { redirect_to anggaran_asbs_url, notice: "Anggaran asb was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_anggaran_asb
    @anggaran_asb = AnggaranAsb.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def anggaran_asb_params
    params.require(:anggaran_asb).permit(:harga_satuan, :id_standar_harga, :kode_barang, :kode_kelompok_barang,
                                         :satuan, :spesifikasi, :tahun, :uraian_barang, :uraian_kelompok_barang, :opd_id)
  end
end
