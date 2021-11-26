class KesenjangansController < ApplicationController
  before_action :set_kesenjangan, only: %i[ show edit update destroy ]

  # GET /kesenjangans or /kesenjangans.json
  def index
    @kesenjangans = Kesenjangan.all
  end

  # GET /kesenjangans/1 or /kesenjangans/1.json
  def show
  end

  # GET /kesenjangans/new
  def new
    @kesenjangan = Kesenjangan.new
  end

  # GET /kesenjangans/1/edit
  def edit
  end

  # POST /kesenjangans or /kesenjangans.json
  def create
    @kesenjangan = Kesenjangan.new(kesenjangan_params)

    respond_to do |format|
      if @kesenjangan.save
        format.html { redirect_to @kesenjangan, notice: "Kesenjangan was successfully created." }
        format.json { render :show, status: :created, location: @kesenjangan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @kesenjangan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kesenjangans/1 or /kesenjangans/1.json
  def update
    respond_to do |format|
      if @kesenjangan.update(kesenjangan_params)
        format.html { redirect_to @kesenjangan, notice: "Kesenjangan was successfully updated." }
        format.json { render :show, status: :ok, location: @kesenjangan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kesenjangan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kesenjangans/1 or /kesenjangans/1.json
  def destroy
    @kesenjangan.destroy
    respond_to do |format|
      format.html { redirect_to kesenjangans_url, notice: "Kesenjangan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kesenjangan
      @kesenjangan = Kesenjangan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kesenjangan_params
      params.require(:kesenjangan).permit(:akses, :partisipasi, :kontrol, :manfaat)
    end
end
