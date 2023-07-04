class TahunsController < ApplicationController
  before_action :set_tahun, only: %i[show edit update destroy]

  # GET /tahuns or /tahuns.json
  def index
    @tahuns = Tahun.all
  end

  # GET /tahuns/1 or /tahuns/1.json
  def show; end

  # GET /tahuns/new
  def new
    @tahun = Tahun.new
  end

  # GET /tahuns/1/edit
  def edit; end

  # POST /tahuns or /tahuns.json
  def create
    @tahun = Tahun.new(tahun_params)

    respond_to do |format|
      if @tahun.save
        format.html { redirect_to tahun_url(@tahun), notice: "Tahun was successfully created." }
        format.json { render :show, status: :created, location: @tahun }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tahun.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tahuns/1 or /tahuns/1.json
  def update
    respond_to do |format|
      if @tahun.update(tahun_params)
        format.html { redirect_to tahun_url(@tahun), notice: "Tahun was successfully updated." }
        format.json { render :show, status: :ok, location: @tahun }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tahun.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tahuns/1 or /tahuns/1.json
  def destroy
    @tahun.destroy

    respond_to do |format|
      format.html { redirect_to tahuns_url, notice: "Tahun dihapus." }
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
