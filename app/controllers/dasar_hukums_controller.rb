class DasarHukumsController < ApplicationController
  before_action :set_dasar_hukum, only: %i[ show edit update destroy ]

  # GET /dasar_hukums or /dasar_hukums.json
  def index
    @dasar_hukums = DasarHukum.all
  end

  # GET /dasar_hukums/1 or /dasar_hukums/1.json
  def show
  end

  # GET /dasar_hukums/new
  def new
    @dasar_hukum = DasarHukum.new
  end

  # GET /dasar_hukums/1/edit
  def edit
  end

  # POST /dasar_hukums or /dasar_hukums.json
  def create
    @dasar_hukum = DasarHukum.new(dasar_hukum_params)

    respond_to do |format|
      if @dasar_hukum.save
        format.html { redirect_to dasar_hukums_path, notice: "Dasar hukum was successfully created." }
        format.json { render :show, status: :created, location: @dasar_hukum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dasar_hukum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dasar_hukums/1 or /dasar_hukums/1.json
  def update
    respond_to do |format|
      if @dasar_hukum.update(dasar_hukum_params)
        format.html { redirect_to dasar_hukums_path, notice: "Dasar hukum was successfully updated." }
        format.json { render :show, status: :ok, location: @dasar_hukum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dasar_hukum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dasar_hukums/1 or /dasar_hukums/1.json
  def destroy
    @dasar_hukum.destroy
    respond_to do |format|
      format.html { redirect_to dasar_hukums_url, notice: "Dasar hukum was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dasar_hukum
    @dasar_hukum = DasarHukum.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def dasar_hukum_params
    params.require(:dasar_hukum).permit(:peraturan, :judul, :tahun)
  end
end
