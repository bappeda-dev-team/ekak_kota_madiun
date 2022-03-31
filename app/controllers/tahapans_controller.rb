class TahapansController < ApplicationController
  before_action :get_sasaran
  before_action :set_tahapan, only: %i[show edit update destroy]

  # GET /tahapans or /tahapans.json
  def index
    # @tahapans = Tahapan.all
    @tahapans = @sasaran.tahapans
  end

  def renaksi_update; end

  # GET /tahapans/1 or /tahapans/1.json
  def show; end

  # GET /tahapans/new
  def new
    # @tahapan = Tahapan.new
    @tahapan = @sasaran.tahapans.build
  end

  # GET /tahapans/1/edit
  def edit; end

  # POST /tahapans or /tahapans.json
  def create
    # @tahapan = Tahapan.new(tahapan_params)
    @tahapan = @sasaran.tahapans.build(tahapan_params)
    @tahapan.id_rencana = @sasaran.id_rencana
    @tahapan.id_rencana_aksi = Tahapan.last.id
    respond_to do |format|
      if @tahapan.save
        format.html { redirect_to sasaran_path(@sasaran), notice: 'Tahapan was successfully created.' }
        format.json { render :show, status: :created, location: @tahapan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tahapan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tahapans/1 or /tahapans/1.json
  def update
    respond_to do |format|
      if @tahapan.update(tahapan_params)
        format.html { redirect_to sasaran_path(@sasaran), notice: 'Tahapan was successfully updated.' }
        format.json { render :show, status: :ok, location: @tahapan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tahapan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tahapans/1 or /tahapans/1.json
  def destroy
    @tahapan.destroy
    respond_to do |format|
      format.html { redirect_to sasaran_path(@sasaran), notice: 'Tahapan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def get_sasaran
    @sasaran = Sasaran.find(params[:sasaran_id])
  end

  def set_tahapan
    @tahapan = @sasaran.tahapans.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tahapan_params
    params.require(:tahapan).permit(:sasaran_id, :tahapan_kerja, :target, :realisasi, :bulan, :jumlah_target,
                                    :jumlah_realisasi, :keterangan, :waktu, :progress)
  end
end
