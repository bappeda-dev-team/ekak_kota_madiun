class SasaransController < ApplicationController
  before_action :set_sasaran, only: %i[ show edit update destroy ]
  before_action :set_dropdown, only: %i[ new edit ]

  # GET /sasarans or /sasarans.json
  def index
    @sasarans = Sasaran.all
  end

  # GET /sasarans/1 or /sasarans/1.json
  def show
  end

  # GET /sasarans/new
  def new
    @sasaran = Sasaran.new
  end

  # GET /sasarans/1/edit
  def edit
  end

  # POST /sasarans or /sasarans.json
  def create
    @sasaran = Sasaran.new(sasaran_params)

    respond_to do |format|
      if @sasaran.save
        format.html { redirect_to @sasaran, notice: "Sasaran was successfully created." }
        format.json { render :show, status: :created, location: @sasaran }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sasaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sasarans/1 or /sasarans/1.json
  def update
    respond_to do |format|
      if @sasaran.update(sasaran_params)
        format.html { redirect_to @sasaran, notice: "Sasaran was successfully updated." }
        format.json { render :show, status: :ok, location: @sasaran }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sasaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sasarans/1 or /sasarans/1.json
  def destroy
    @sasaran.destroy
    respond_to do |format|
      format.html { redirect_to sasarans_url, notice: "Sasaran was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sasaran
      @sasaran = Sasaran.find(params[:id])
    end

    def set_dropdown
      @users = User.all
    end

    # Only allow a list of trusted parameters through.
    def sasaran_params
      params.require(:sasaran).permit(:sasaran_kinerja, :indikator_kinerja, :target, :kualitas, :satuan, :penerima_manfaat, :user_id)
    end
end
