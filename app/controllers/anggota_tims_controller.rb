class AnggotaTimsController < ApplicationController
  before_action :set_anggota_tim, only: %i[ show edit update destroy ]

  # GET /anggota_tims or /anggota_tims.json
  def index
    @anggota_tims = AnggotaTim.all
  end

  # GET /anggota_tims/1 or /anggota_tims/1.json
  def show
  end

  # GET /anggota_tims/new
  def new
    @anggota_tim = AnggotaTim.new
  end

  # GET /anggota_tims/1/edit
  def edit
  end

  # POST /anggota_tims or /anggota_tims.json
  def create
    @anggota_tim = AnggotaTim.new(anggota_tim_params)

    respond_to do |format|
      if @anggota_tim.save
        format.html { redirect_to anggota_tim_url(@anggota_tim), notice: "Anggota tim was successfully created." }
        format.json { render :show, status: :created, location: @anggota_tim }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @anggota_tim.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /anggota_tims/1 or /anggota_tims/1.json
  def update
    respond_to do |format|
      if @anggota_tim.update(anggota_tim_params)
        format.html { redirect_to anggota_tim_url(@anggota_tim), notice: "Anggota tim was successfully updated." }
        format.json { render :show, status: :ok, location: @anggota_tim }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @anggota_tim.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anggota_tims/1 or /anggota_tims/1.json
  def destroy
    @anggota_tim.destroy

    respond_to do |format|
      format.html { redirect_to anggota_tims_url, notice: "Anggota tim was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_anggota_tim
      @anggota_tim = AnggotaTim.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def anggota_tim_params
      params.require(:anggota_tim).permit(:nama, :role, :keterangan, :tahun, :metadata, :tim_id)
    end
end
