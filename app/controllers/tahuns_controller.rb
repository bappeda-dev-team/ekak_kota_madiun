class TahunsController < ApplicationController
  before_action :set_tahun, only: %i[show edit update destroy]

  # GET /tahuns or /tahuns.json
  def index
    @tahuns = Tahun.all.order(:tahun)
  end

  # GET /tahuns/1 or /tahuns/1.json
  def show; end

  # GET /tahuns/new
  def new
    @tahun = Tahun.new
  end

  # GET /tahuns/1/edit
  def edit
    respond_to do |f|
      f.js { render :new }
      f.html { render :edit }
    end
  end

  # POST /tahuns or /tahuns.json
  def create
    @tahun = Tahun.new(tahun_params)

    if @tahun.save
      render json: @tahun, status: :created
    else
      render json: @tahun.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tahuns/1 or /tahuns/1.json
  def update
    if @tahun.update(tahun_params)
      render json: @tahun, status: :ok
    else
      render json: @tahun.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tahuns/1 or /tahuns/1.json
  def destroy
    @tahun.destroy

    respond_to do |format|
      format.html { redirect_to tahuns_url, warning: "Tahun dihapus." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tahun
    @tahun = Tahun.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tahun_params
    params.require(:tahun).permit(:tahun, :periode_id)
  end
end
