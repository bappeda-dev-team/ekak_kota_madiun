class HukumsController < ApplicationController
  before_action :set_hukum, only: %i[ show edit update destroy ]

  # GET /hukums or /hukums.json
  def index
    @hukums = Hukum.all
  end

  # GET /hukums/1 or /hukums/1.json
  def show
  end

  # GET /hukums/new
  def new
    @hukum = Hukum.new
  end

  # GET /hukums/1/edit
  def edit
  end

  # POST /hukums or /hukums.json
  def create
    @hukum = Hukum.new(hukum_params)

    respond_to do |format|
      if @hukum.save
        format.html { redirect_to @hukum, notice: "Hukum was successfully created." }
        format.json { render :show, status: :created, location: @hukum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @hukum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hukums/1 or /hukums/1.json
  def update
    respond_to do |format|
      if @hukum.update(hukum_params)
        format.html { redirect_to @hukum, notice: "Hukum was successfully updated." }
        format.json { render :show, status: :ok, location: @hukum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @hukum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hukums/1 or /hukums/1.json
  def destroy
    @hukum.destroy
    respond_to do |format|
      format.html { redirect_to hukums_url, notice: "Hukum was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hukum
      @hukum = Hukum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hukum_params
      params.require(:hukum).permit(:dasar_hukum, :kak_id)
    end
end
