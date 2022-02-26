class AnggaransController < ApplicationController
  before_action :set_tahapan_rincian
  before_action :set_anggaran, only: %i[ show edit update destroy ]

  # GET /anggarans or /anggarans.json
  def index
    @anggarans = Anggaran.all
  end

  # GET /anggarans/1 or /anggarans/1.json
  def show
  end

  # GET /anggarans/new
  def new
    # @anggaran = Anggaran.new
    @anggaran = Anggaran.new
    @parent = params[:parent]
    @level = params[:level]
  end

  # GET /anggarans/1/edit
  def edit
  end

  # POST /anggarans or /anggarans.json
  def create
    sleep 1
    # @anggaran = Anggaran.new(anggaran_params)
    @anggaran = @tahapan.anggarans.build(anggaran_params)
    rekening = Rekening.find(anggaran_params[:kode_rek])
    uraian = rekening.jenis_rekening
    kode_rekening = rekening.kode_rekening
    @anggaran.kode_rek = kode_rekening
    @anggaran.uraian = uraian
    @anggaran.level = 4
    respond_to do |format|
      if @anggaran.save
        format.js
        format.html { redirect_to sasaran_path(@rincian.sasaran), notice: "Anggaran was successfully created." }
        format.json { render :show, status: :created, location: @anggaran }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @anggaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /anggarans/1 or /anggarans/1.json
  def update
    respond_to do |format|
      if @anggaran.update(anggaran_params)
        format.html { redirect_to rincian_tahapan_anggaran_path(@rincian, @tahapan, @anggaran), notice: "Anggaran was successfully updated." }
        format.json { render :show, status: :ok, location: @anggaran }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @anggaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anggarans/1 or /anggarans/1.json
  def destroy
    @anggaran.destroy
    respond_to do |format|
      format.html { redirect_to sasaran_path(@rincian.sasaran), notice: "Anggaran was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tahapan_rincian
    @rincian = Rincian.find(params[:rincian_id])
    @tahapan = @rincian.tahapans.find(params[:tahapan_id])
  end

  def set_anggaran
    @anggaran = Anggaran.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def anggaran_params
    params.require(:anggaran).permit(:kode_rek, :uraian, :jumlah, :tahapan_id, :parent_id, :level, :pajak_id)
  end
end
