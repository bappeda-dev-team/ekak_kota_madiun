class KelompokAnggaransController < ApplicationController
  before_action :set_kelompok_anggaran, only: %i[ show edit update destroy ]

  # GET /kelompok_anggarans or /kelompok_anggarans.json
  def index
    @kelompok_anggarans = KelompokAnggaran.all
  end

  def cloning
    @kelompok_anggarans = KelompokAnggaran.all
  end

  # GET /kelompok_anggarans/1 or /kelompok_anggarans/1.json
  def show
  end

  # GET /kelompok_anggarans/new
  def new
    @kelompok_anggaran = KelompokAnggaran.new
  end

  # GET /kelompok_anggarans/1/edit
  def edit
    respond_to { |f| f.js { render :new } }
  end

  # POST /kelompok_anggarans or /kelompok_anggarans.json
  def create
    @kelompok_anggaran = KelompokAnggaran.new(kelompok_anggaran_params)

    respond_to do |format|
      if @kelompok_anggaran.save
        format.html { redirect_to kelompok_anggarans_url, notice: "Kelompok anggaran telah berhasil dibuat" }
        format.js { redirect_to kelompok_anggarans_url, notice: "Kelompok anggaran telah berhasil dibuat" }
        format.json { render :show, status: :created, location: @kelompok_anggaran }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js { render :new, status: :unprocessable_entity }
        format.json { render json: @kelompok_anggaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kelompok_anggarans/1 or /kelompok_anggarans/1.json
  def update
    respond_to do |format|
      if @kelompok_anggaran.update(kelompok_anggaran_params)
        format.html { redirect_to kelompok_anggarans_url, notice: "Kelompok anggaran #{@kelompok_anggaran.tahun_previously_was} berhasil diupdate" }
        format.json { render :show, status: :ok, location: @kelompok_anggaran }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.js { render :new, status: :unprocessable_entity }
        format.json { render json: @kelompok_anggaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kelompok_anggarans/1 or /kelompok_anggarans/1.json
  def destroy
    @kelompok_anggaran.destroy

    respond_to do |format|
      format.html { redirect_to kelompok_anggarans_url, notice: "Kelompok anggaran telah berhasil dihapus" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kelompok_anggaran
      @kelompok_anggaran = KelompokAnggaran.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kelompok_anggaran_params
      params.require(:kelompok_anggaran).permit(:kode_kelompok, :tahun, :kelompok)
    end
end
