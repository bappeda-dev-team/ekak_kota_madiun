class PerhitungansController < ApplicationController
  before_action :set_anggaran
  before_action :set_perhitungan, only: %i[show edit update destroy]

  # GET /perhitungans or /perhitungans.json
  def index
    @perhitungans = @anggaran.perhitungans
  end

  # GET /perhitungans/1 or /perhitungans/1.json
  def show; end

  # GET /perhitungans/new
  def new
    @perhitungan = Perhitungan.new
    @perhitungan.koefisiens.build
  end

  # GET /perhitungans/1/edit
  def edit; end

  # POST /perhitungans or /perhitungans.json
  def create
    sleep 1
    @perhitungan = @anggaran.perhitungans.build(perhitungan_params)
    respond_to do |format|
      if @perhitungan.save
        format.js
        format.html do
          redirect_to sasaran_tahapan_anggaran_path(@anggaran.tahapan.sasaran, @anggaran.tahapan),
                      notice: 'Perhitungan was successfully created.'
        end
        format.json { render :show, status: :created, location: @perhitungan }
      else
        format.js { render :new, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @perhitungan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /perhitungans/1 or /perhitungans/1.json
  def update
    respond_to do |format|
      if @perhitungan.update(perhitungan_params)
        format.html do
          redirect_to sasaran_tahapan_anggaran_path(@anggaran.tahapan.sasaran, @anggaran.tahapan),
                      notice: "#{@perhitungan.deskripsi} updated."
        end
        format.json { render :show, status: :ok, location: @perhitungan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @perhitungan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /perhitungans/1 or /perhitungans/1.json
  def destroy
    @perhitungan.destroy
    respond_to do |format|
      format.html do
        redirect_to sasaran_tahapan_anggarans_path(@anggaran.tahapan.sasaran, @anggaran.tahapan),
                    notice: 'Rincian Anggaran dihapus'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_anggaran
    @anggaran = Anggaran.find(params[:anggaran_id])
  end

  def set_perhitungan
    @perhitungan = @anggaran.perhitungans.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def perhitungan_params
    params.require(:perhitungan).permit(:satuan,
                                        :harga, :anggaran_id, :deskripsi, :pajak_id,
                                        koefisiens_attributes: %i[id volume satuan_volume])
  end
end
