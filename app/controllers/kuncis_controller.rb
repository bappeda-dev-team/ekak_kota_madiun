class KuncisController < ApplicationController
  before_action :set_kunci, only: %i[ show edit update destroy ]

  # GET /kuncis or /kuncis.json
  def index
    @kuncis = Kunci.all
  end

  # GET /kuncis/1 or /kuncis/1.json
  def show
  end

  # GET /kuncis/new
  def new
    @kunci = Kunci.new
  end

  # GET /kuncis/1/edit
  def edit
  end

  # POST /kuncis or /kuncis.json
  def create
    @kunci = Kunci.new(kunci_params)

    respond_to do |format|
      if @kunci.save
        format.html { redirect_to kunci_url(@kunci), notice: "Kunci was successfully created." }
        format.json { render :show, status: :created, location: @kunci }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @kunci.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kuncis/1 or /kuncis/1.json
  def update
    respond_to do |format|
      if @kunci.update(kunci_params)
        format.html { redirect_to kunci_url(@kunci), notice: "Kunci was successfully updated." }
        format.json { render :show, status: :ok, location: @kunci }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kunci.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kuncis/1 or /kuncis/1.json
  def destroy
    @kunci.destroy

    respond_to do |format|
      format.html { redirect_to kuncis_url, notice: "Kunci was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kunci
      @kunci = Kunci.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kunci_params
      params.require(:kunci).permit(:jenis, :status_kunci, :item, :dikunci_oleh, :keterangan)
    end
end
