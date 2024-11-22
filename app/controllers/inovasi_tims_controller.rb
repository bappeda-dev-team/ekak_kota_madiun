class InovasiTimsController < ApplicationController
  before_action :set_inovasi_tim, only: %i[ show edit update destroy ]

  # GET /inovasi_tims or /inovasi_tims.json
  def index
    @inovasi_tims = InovasiTim.all
  end

  # GET /inovasi_tims/1 or /inovasi_tims/1.json
  def show
  end

  # GET /inovasi_tims/new
  def new
    @inovasi_tim = InovasiTim.new
  end

  # GET /inovasi_tims/1/edit
  def edit
  end

  # POST /inovasi_tims or /inovasi_tims.json
  def create
    @inovasi_tim = InovasiTim.new(inovasi_tim_params)

    respond_to do |format|
      if @inovasi_tim.save
        format.html { redirect_to inovasi_tim_url(@inovasi_tim), notice: "Inovasi tim was successfully created." }
        format.json { render :show, status: :created, location: @inovasi_tim }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inovasi_tim.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inovasi_tims/1 or /inovasi_tims/1.json
  def update
    respond_to do |format|
      if @inovasi_tim.update(inovasi_tim_params)
        format.html { redirect_to inovasi_tim_url(@inovasi_tim), notice: "Inovasi tim was successfully updated." }
        format.json { render :show, status: :ok, location: @inovasi_tim }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inovasi_tim.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inovasi_tims/1 or /inovasi_tims/1.json
  def destroy
    @inovasi_tim.destroy

    respond_to do |format|
      format.html { redirect_to inovasi_tims_url, notice: "Inovasi tim was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inovasi_tim
      @inovasi_tim = InovasiTim.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def inovasi_tim_params
      params.require(:inovasi_tim).permit(:nama_inovasi, :jenis_inovasi, :nilai_kebaruan, :tahun, :crosscutting_id)
    end
end
