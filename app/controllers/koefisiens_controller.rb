class KoefisiensController < ApplicationController
  before_action :set_anggaran_perhitungan
  before_action :set_koefisien, only: %i[ show edit update destroy ]

  # GET /koefisiens or /koefisiens.json
  def index
    @koefisiens = Koefisien.all
  end

  # GET /koefisiens/1 or /koefisiens/1.json
  def show
  end

  # GET /koefisiens/new
  def new
    @koefisien = Koefisien.new
  end

  # GET /koefisiens/1/edit
  def edit
  end

  # POST /koefisiens or /koefisiens.json
  def create
    @koefisien = Koefisien.new(koefisien_params)

    respond_to do |format|
      if @koefisien.save
        format.html { redirect_to @koefisien, notice: "Koefisien was successfully created." }
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
    def set_anggaran_perhitungan
      @anggaran = Anggaran.find(params[:anggaran_id])
      @perhitungan = @anggaran.find(params[:perhitungan_id])
    end

    def set_koefisien
      @koefisien = Koefisien.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def koefisien_params
      params.require(:koefisien).permit(:volume, :satuan_volume, :perhitungan_id)
    end
end
