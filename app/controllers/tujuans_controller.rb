class TujuansController < ApplicationController
  before_action :set_tujuan, only: %i[show edit update destroy]

  # GET /tujuans or /tujuans.json
  def index
    @tujuans = Tujuan.all
  end

  # GET /tujuans/1 or /tujuans/1.json
  def show
  end

  # GET /tujuans/new
  def new
    @tujuan = Tujuan.new
  end

  # GET /tujuans/1/edit
  def edit
  end

  # POST /tujuans or /tujuans.json
  def create
    @tujuan = Tujuan.new(tujuan_params)

    respond_to do |format|
      if @tujuan.save
        format.html { redirect_to tujuan_url(@tujuan), notice: "Tujuan was successfully created." }
        format.json { render :show, status: :created, location: @tujuan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tujuan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tujuans/1 or /tujuans/1.json
  def update
    respond_to do |format|
      if @tujuan.update(tujuan_params)
        format.html { redirect_to tujuan_url(@tujuan), notice: "Tujuan was successfully updated." }
        format.json { render :show, status: :ok, location: @tujuan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tujuan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tujuans/1 or /tujuans/1.json
  def destroy
    @tujuan.destroy

    respond_to do |format|
      format.html { redirect_to tujuans_url, notice: "Tujuan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tujuan
    @tujuan = Tujuan.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tujuan_params
    params.require(:tujuan).permit(:tujuan, :id_tujuan, :type)
  end
end
