class KoefisiensController < ApplicationController
  before_action :set_perhitungan, except: %i[edit show]
  before_action :set_koefisien, only: %i[show edit update destroy]

  # GET /koefisiens or /koefisiens.json
  def index
    @koefisiens = @perhitungan.koefisiens
  end

  # GET /koefisiens/1 or /koefisiens/1.json
  def show; end

  # GET /koefisiens/new
  def new
    @koefisien = @perhitungan.koefisiens.build
  end

  # GET /koefisiens/1/edit
  def edit; end

  # POST /koefisiens or /koefisiens.json
  def create
    @koefisien = @perhitungan.koefisiens.build(koefisien_params)

    respond_to do |format|
      if @koefisien.save
        format.html do
          redirect_to rincian_tahapan_anggarans_path(@anggaran.tahapan.rincian, @anggaran.tahapan),
                      notice: "Koefisien was successfully created."
        end
        format.json { render :show, status: :created, location: @koefisien }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @koefisien.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /koefisiens/1 or /koefisiens/1.json
  def update
    respond_to do |format|
      if @koefisien.update(koefisien_params)
        format.html { redirect_to @koefisien, notice: "Koefisien was successfully updated." }
        format.json { render :show, status: :ok, location: @koefisien }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @koefisien.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /koefisiens/1 or /koefisiens/1.json
  def destroy
    @koefisien.destroy
    respond_to do |format|
      format.html { redirect_to koefisiens_url, notice: "Koefisien was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_perhitungan
    @perhitungan = Perhitungan.find(params[:perhitungan_id])
    @anggaran = @perhitungan.anggaran
  end

  def set_koefisien
    @koefisien = Koefisien.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def koefisien_params
    params.require(:koefisien).permit(:volume, :satuan_volume, :perhitungan_id)
  end
end
