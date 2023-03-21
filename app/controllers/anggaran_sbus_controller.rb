class AnggaranSbusController < ApplicationController
  before_action :set_anggaran_sbus, only: %i[show edit update destroy]

  # GET /anggaran_sbus or /anggaran_sbus.json
  def index
    @anggaran_sbus = AnggaranSbu.all
  end

  # GET /anggaran_sbus/1 or /anggaran_sbus/1.json
  def show; end

  # GET /anggaran_sbus/new
  def new
    @anggaran_sbus = AnggaranSbu.new
  end

  # GET /anggaran_sbus/1/edit
  def edit; end

  # POST /anggaran_sbus or /anggaran_sbus.json
  def create
    @anggaran_sbus = AnggaranSbu.new(anggaran_sbus_params)

    respond_to do |format|
      if @anggaran_sbus.save
        format.html { redirect_to @anggaran_sbus, notice: "Anggaran sbu was successfully created." }
        format.json { render :show, status: :created, location: @anggaran_sbus }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @anggaran_sbus.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /anggaran_sbus/1 or /anggaran_sbus/1.json
  def update
    respond_to do |format|
      if @anggaran_sbus.update(anggaran_sbus_params)
        format.html { redirect_to @anggaran_sbus, notice: "Anggaran sbu was successfully updated." }
        format.json { render :show, status: :ok, location: @anggaran_sbus }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @anggaran_sbus.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anggaran_sbus/1 or /anggaran_sbus/1.json
  def destroy
    @anggaran_sbus.destroy
    respond_to do |format|
      format.html { redirect_to anggaran_sbus_url, notice: "Anggaran sbu was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_anggaran_sbus
    @anggaran_sbus = AnggaranSbu.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def anggaran_sbus_params
    params.require(:anggaran_sbus).permit(:kode_kelompok_barang, :uraian_kelompok_barang, :kode_barang,
                                          :tahun, :id_standar_harga,
                                          :uraian_barang, :spesifikasi, :satuan, :harga_satuan)
  end
end
