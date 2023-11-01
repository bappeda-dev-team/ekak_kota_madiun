class StatusTombolsController < ApplicationController
  before_action :set_status_tombol, only: %i[show edit update destroy]

  # GET /status_tombols or /status_tombols.json
  def index
    @status_tombols = StatusTombol.all
  end

  # GET /status_tombols/1 or /status_tombols/1.json
  def show; end

  # GET /status_tombols/new
  def new
    @status_tombol = StatusTombol.new
  end

  # GET /status_tombols/1/edit
  def edit; end

  # POST /status_tombols or /status_tombols.json
  def create
    @status_tombol = StatusTombol.new(status_tombol_params)

    respond_to do |format|
      if @status_tombol.save
        format.html { redirect_to status_tombol_url(@status_tombol), notice: "Status tombol was successfully created." }
        format.json { render :show, status: :created, location: @status_tombol }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @status_tombol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /status_tombols/1 or /status_tombols/1.json
  def update
    respond_to do |format|
      if @status_tombol.update(status_tombol_params)
        format.html { redirect_to status_tombol_url(@status_tombol), notice: "Status tombol was successfully updated." }
        format.json { render :show, status: :ok, location: @status_tombol }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @status_tombol.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /status_tombols/1 or /status_tombols/1.json
  def destroy
    @status_tombol.destroy

    respond_to do |format|
      format.html { redirect_to status_tombols_url, notice: "Status tombol was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_status_tombol
    @status_tombol = StatusTombol.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def status_tombol_params
    params.require(:status_tombol).permit(:tombol, :kode_tombol, :disabled, :tahun, :kode_opd, :keterangan)
  end
end
