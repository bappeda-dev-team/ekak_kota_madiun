class RinciansController < ApplicationController
  before_action :get_sasaran, only: %i[index create new]
  before_action :set_rincian, only: %i[ show edit update destroy ]
  before_action :set_dropdown, only: %i[ new edit ]

  # GET /rincians or /rincians.json
  def index
    @rincians = @sasaran.rincian
  end

  # GET /rincians/1 or /rincians/1.json
  def show
  end

  # GET /rincians/new
  def new
    @rincian = @sasaran.build_rincian
  end

  # GET /rincians/1/edit
  def edit
  end

  # POST /rincians or /rincians.json
  def create
    @rincian = @sasaran.build_rincian(rincian_params)

    respond_to do |format|
      if @rincian.save
        format.html { redirect_to user_path(@sasaran.user), notice: "Rincian was successfully created." }
        format.json { render :show, status: :created, location: @rincian }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rincian.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rincians/1 or /rincians/1.json
  def update
    respond_to do |format|
      if @rincian.update(rincian_params)
        format.html { redirect_to sasaran_path(@sasaran), notice: "Rincian was successfully updated." }
        format.json { render :show, status: :ok, location: @rincian }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rincian.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rincians/1 or /rincians/1.json
  def destroy
    @rincian.destroy
    respond_to do |format|
      format.html { redirect_to sasaran_path(@sasaran), notice: "Rincian was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def get_sasaran
    @sasaran = Sasaran.find(params[:sasaran_id])
  end

  def set_rincian
    @rincian = Rincian.find(params[:id])
  end

  def set_dropdown
    @sasarans = Sasaran.all
  end

  # Only allow a list of trusted parameters through.
  def rincian_params
    params.require(:rincian).permit(:data_terpilah, :penyebab_internal, :penyebab_external, :permasalahan_umum, :permasalahan_gender, :resiko, :lokasi_pelaksanaan, :sasaran_id)
  end
end
