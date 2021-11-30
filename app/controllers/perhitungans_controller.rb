class PerhitungansController < ApplicationController
  before_action :set_perhitungan, only: %i[ show edit update destroy ]

  # GET /perhitungans or /perhitungans.json
  def index
    @perhitungans = Perhitungan.all
  end

  # GET /perhitungans/1 or /perhitungans/1.json
  def show
  end

  # GET /perhitungans/new
  def new
    @perhitungan = Perhitungan.new
  end

  # GET /perhitungans/1/edit
  def edit
  end

  # POST /perhitungans or /perhitungans.json
  def create
    @perhitungan = Perhitungan.new(perhitungan_params)

    respond_to do |format|
      if @perhitungan.save
        format.html { redirect_to @perhitungan, notice: "Perhitungan was successfully created." }
        format.json { render :show, status: :created, location: @perhitungan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @perhitungan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /perhitungans/1 or /perhitungans/1.json
  def update
    respond_to do |format|
      if @perhitungan.update(perhitungan_params)
        format.html { redirect_to @perhitungan, notice: "Perhitungan was successfully updated." }
        format.json { render :show, status: :ok, location: @perhitungan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @perhitungan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /perhitungans/1 or /perhitungans/1.json
  def destroy
    @perhitungan.destroy
    respond_to do |format|
      format.html { redirect_to perhitungans_url, notice: "Perhitungan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_perhitungan
      @perhitungan = Perhitungan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def perhitungan_params
      params.require(:perhitungan).permit(:koefisien, :volume, :satuan, :harga)
    end
end
