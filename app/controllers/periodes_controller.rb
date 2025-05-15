class PeriodesController < ApplicationController
  before_action :set_periode, only: %i[show edit update destroy]
  layout false, only: %i[new]

  # GET /periodes or /periodes.json
  def index
    @tahun = cookies[:tahun]
    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periodes = Periode
                .find_tahun_all(tahun_bener)
                .where(jenis_periode: params[:jenis_uraian])
                .or(Periode.where(id: params[:selected]))
                .presence || Periode.all
  end

  # GET /periodes/1 or /periodes/1.json
  def show; end

  # GET /periodes/new
  def new
    @periode = Periode.new
  end

  # GET /periodes/1/edit
  def edit
    respond_to do |f|
      f.js { render :new }
      f.html { render :edit }
    end
  end

  # POST /periodes or /periodes.json
  def create
    @periode = Periode.new(periode_params)

    if @periode.save
      render json: @periode, status: :created
    else
      render json: @periode.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /periodes/1 or /periodes/1.json
  def update
    if @periode.update(periode_params)
      render json: @periode, status: :ok
    else
      render json: @periode.errors, status: :unprocessable_entity
    end
  end

  # DELETE /periodes/1 or /periodes/1.json
  def destroy
    @periode.destroy

    respond_to do |format|
      format.html { redirect_to periodes_url, warning: "Periode was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_periode
    @periode = Periode.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def periode_params
    params.require(:periode).permit(:tahun_awal, :tahun_akhir, :jenis_periode)
  end
end
