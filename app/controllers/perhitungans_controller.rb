class PerhitungansController < ApplicationController
  before_action :set_anggaran
  before_action :set_perhitungan, only: %i[show edit update destroy edit_gaji edit_lain_lain]

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
  def edit
    @selected = @perhitungan.deskripsi_anggaran

    @jenis_anggaran = if @perhitungan.jenis_anggaran.blank?
                        @selected.first&.searchable_type
                      else
                        @perhitungan.jenis_anggaran
                      end
  end

  # POST /perhitungans or /perhitungans.json
  def create
    @perhitungan = @anggaran.perhitungans.build(perhitungan_params)
    respond_to do |format|
      if @perhitungan.save
        format.js
        format.html do
          redirect_to sasaran_tahapan_anggarans_path(@anggaran.tahapan.sasaran, @anggaran.tahapan),
                      success: 'Perhitungan was successfully created.'
        end
        format.json { render :show, status: :created, location: @perhitungan }
      else
        format.js { render :new, status: :unprocessable_entity }
        format.html do
          redirect_to sasaran_tahapan_anggarans_path(@anggaran.tahapan.sasaran, @anggaran.tahapan),
                      error: 'Terjadi Kesalahan'
        end
        format.json { render json: @perhitungan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /perhitungans/1 or /perhitungans/1.json
  def update
    respond_to do |format|
      if @perhitungan.update(perhitungan_params)
        format.js { render :create }
        format.html do
          redirect_to sasaran_tahapan_anggarans_path(@anggaran.tahapan.sasaran, @anggaran.tahapan),
                      success: "Anggaran terupdate."
        end
        format.json { render :show, status: :ok, location: @perhitungan }
      else
        format.js { render :edit, status: :unprocessable_entity }
        format.html do
          redirect_to sasaran_tahapan_anggarans_path(@anggaran.tahapan.sasaran, @anggaran.tahapan),
                      error: 'Terjadi Kesalahan'
        end
        format.json { render json: @perhitungan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /perhitungans/1 or /perhitungans/1.json
  def destroy
    @perhitungan.destroy
    respond_to do |format|
      format.js { render :create }
      format.html do
        redirect_to sasaran_tahapan_anggarans_path(@anggaran.tahapan.sasaran, @anggaran.tahapan),
                    notice: 'Rincian Anggaran dihapus'
      end
      format.json { head :no_content }
    end
  end

  def new_gaji
    @perhitungan = Perhitungan.new
    @perhitungan.koefisiens.build
  end

  def edit_gaji; end

  def new_lain_lain
    @perhitungan = Perhitungan.new
    @perhitungan.koefisiens.build
  end

  def edit_lain_lain; end

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
    params.require(:perhitungan).permit(:satuan, :spesifikasi, :tahun,
                                        :harga, :anggaran_id, :deskripsi, :pajak_id,
                                        :jenis_anggaran, :barang_id,
                                        koefisiens_attributes: %i[id volume satuan_volume _destroy])
  end
end
