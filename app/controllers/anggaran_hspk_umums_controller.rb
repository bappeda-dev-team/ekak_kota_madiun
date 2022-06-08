class AnggaranHspkUmumsController < ApplicationController
  before_action :set_anggaran_hspk_umum, only: %i[ show edit update destroy ]

  def index
    @anggaran_hspk_umum = AnggaranHspkUmum.all
  end

  def show
  end

  def new
    @anggaran_hspk_umum = AnggaranHspkUmum.new
  end

  # GET /anggaran_hspk_umums/1/edit
  def edit
    respond_to do |f|
      f.js { render 'new.js.erb' }
      f.html
    end
  end

  # POST /anggaran_hspk_umums or /anggaran_hspk_umums.json
  def create
    @anggaran_hspk_umum = AnggaranHspkUmum.new(anggaran_hspk_umum_params)
    hspk_finder = AnggaranHspk.find(anggaran_hspk_umum_params[:hspk_id])
    @anggaran_hspk_umum.kode_barang = hspk_finder.kode_barang
    @anggaran_hspk_umum.uraian_kelompok_barang = hspk_finder.uraian_kelompok_barang
    @anggaran_hspk_umum.kode_kelompok_barang = hspk_finder.kode_kelompok_barang
    respond_to do |format|
      if @anggaran_hspk_umum.save
        @status = 'success'
        @text = 'Anggaran PU Ditambahkan'
        format.js
        format.html { redirect_to anggaran_hspk_umums_url, success: @text }
        format.json { render :show, status: :created, location: @anggaran_hspk_umum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @anggaran_hspk_umum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /anggaran_hspk_umums/1 or /anggaran_hspk_umums/1.json
  def update
    respond_to do |format|
      if @anggaran_hspk_umum.update(anggaran_hspk_umum_params)
        @status = 'success'
        @text = 'Anggaran Blud diupdate'
        flash[:success] = "Permaslahaan diupdate"
        format.html { redirect_to anggaran_hspk_umums_url, success: @text }
        format.json { render :show, status: :ok, location: @anggaran_hspk_umum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @anggaran_hspk_umum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anggaran_hspk_umums/1 or /anggaran_hspk_umums/1.json
  def destroy
    @anggaran_hspk_umum.destroy

    respond_to do |format|
      format.html { redirect_to anggaran_hspk_umums_url, success: "Anggaran dihapus." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_anggaran_hspk_umum
    @anggaran_hspk_umum = AnggaranHspkUmum.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def anggaran_hspk_umum_params
    params.require(:anggaran_hspk_umum).permit(:kode_kelompok_barang, :uraian_kelompok_barang, :kode_barang, :tahun, :hspk_id,
                                               :uraian_barang, :spesifikasi, :satuan, :harga_satuan)
  end
end
