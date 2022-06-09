class AnggaransController < ApplicationController
  before_action :set_tahapan_rincian, except: %i[perhitungan_update]
  before_action :set_anggaran, only: %i[show edit update destroy perhitungan_update]

  # GET /anggarans or /anggarans.json
  def index
    @anggarans = @tahapan.anggarans.includes(%i[perhitungans pajak]).all
  end

  # GET /anggarans/1 or /anggarans/1.json
  def show; end

  # GET /anggarans/new
  def new
    # @anggaran = Anggaran.new
    @anggaran = Anggaran.new
    @parent = params[:parent]
    @level = params[:level]
  end

  # GET /anggarans/1/edit
  def edit; end

  # POST /anggarans or /anggarans.json
  def create
    # @anggaran = Anggaran.new(anggaran_params)
    @anggaran = @tahapan.anggarans.build(anggaran_params)
    rekening = Rekening.find(anggaran_params[:kode_rek])
    uraian = rekening.jenis_rekening
    kode_rekening = rekening.kode_rekening
    @anggaran.uraian = uraian
    @anggaran.level = helpers.anggaran_level(kode_rekening)
    respond_to do |format|
      if @anggaran.save
        format.js
        format.html do
          redirect_to sasaran_tahapan_anggarans_path(@sasaran, @tahapan),
                      success: 'Sukses Membuat Anggaran.'
        end
        format.json { render :show, status: :created, location: @anggaran }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @anggaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /anggarans/1 or /anggarans/1.json
  def update
    # TODO: UPDATE ON HOW TO UPDATE KODE REKNEING DYNAMICLY
    rekening = Rekening.find(anggaran_params[:kode_rek])
    uraian = rekening.jenis_rekening
    kode_rekening = rekening.kode_rekening
    @anggaran.kode_rek = kode_rekening
    @anggaran.uraian = uraian
    @anggaran.level = helpers.anggaran_level kode_rekening
    respond_to do |format|
      if @anggaran.update(anggaran_params)
        format.html do
          redirect_to sasaran_tahapan_anggarans_path(@sasaran, @tahapan),
                      success: 'Anggaran was successfully updated.'
        end
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
      format.html do
        redirect_to sasaran_tahapan_anggarans_path(@sasaran, @tahapan), notice: 'Anggaran was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  def perhitungan_update
    @anggaran.sync_total_perhitungan
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tahapan_rincian
    @sasaran = Sasaran.find(params[:sasaran_id])
    @tahapan = @sasaran.tahapans.find(params[:tahapan_id])
  end

  def set_anggaran
    @anggaran = Anggaran.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def anggaran_params
    params.require(:anggaran).permit(:kode_rek, :uraian, :jumlah, :tahapan_id, :parent_id, :level, :pajak_id)
  end
end
