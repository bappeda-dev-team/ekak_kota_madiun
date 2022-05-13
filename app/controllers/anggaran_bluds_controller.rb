class AnggaranBludsController < ApplicationController
  before_action :set_anggaran_blud, only: %i[ show edit update destroy ]

  # GET /anggaran_bluds or /anggaran_bluds.json
  def index
    @anggaran_bluds = AnggaranBlud.all
  end

  # GET /anggaran_bluds/1 or /anggaran_bluds/1.json
  def show
  end

  # GET /anggaran_bluds/new
  def new
    @anggaran_blud = AnggaranBlud.new
  end

  # GET /anggaran_bluds/1/edit
  def edit
    respond_to do |f|
      f.js { render 'new.js.erb' }
      f.html
    end
  end

  # POST /anggaran_bluds or /anggaran_bluds.json
  def create
    @anggaran_blud = AnggaranBlud.new(anggaran_blud_params)

    respond_to do |format|
      if @anggaran_blud.save
        @status = 'success'
        @text = 'Anggaran Blud ditambahkan'
        flash[:success] = "Permaslahaan ditambahkan"
        format.js
        format.html { redirect_to anggaran_bluds_url, success: @text }
        format.json { render :show, status: :created, location: @anggaran_blud }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @anggaran_blud.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /anggaran_bluds/1 or /anggaran_bluds/1.json
  def update
    respond_to do |format|
      if @anggaran_blud.update(anggaran_blud_params)
        @status = 'success'
        @text = 'Anggaran Blud diupdate'
        flash[:success] = "Permaslahaan diupdate"
        format.html { redirect_to anggaran_bluds_url, success: @text }
        format.json { render :show, status: :ok, location: @anggaran_blud }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @anggaran_blud.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anggaran_bluds/1 or /anggaran_bluds/1.json
  def destroy
    @anggaran_blud.destroy

    respond_to do |format|
      format.html { redirect_to anggaran_bluds_url, success: "Anggaran dihapus." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_anggaran_blud
    @anggaran_blud = AnggaranBlud.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def anggaran_blud_params
    params.require(:anggaran_blud).permit(:kode_kelompok_barang, :uraian_kelompok_barang, :kode_barang, :uraian_barang,
                                          :spesifikasi, :satuan, :harga_satuan)
  end
end
