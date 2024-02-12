class KepegawaiansController < ApplicationController
  before_action :set_kepegawaian, only: %i[ show edit update destroy ]

  # GET /kepegawaians or /kepegawaians.json
  def index
    @kepegawaians = Kepegawaian.all
  end

  # GET /kepegawaians/1 or /kepegawaians/1.json
  def show
  end

  # GET /kepegawaians/new
  def new
    @kepegawaian = Kepegawaian.new
  end

  # GET /kepegawaians/1/edit
  def edit
  end

  # POST /kepegawaians or /kepegawaians.json
  def create
    @kepegawaian = Kepegawaian.new(kepegawaian_params)

    respond_to do |format|
      if @kepegawaian.save
        format.html { redirect_to kepegawaian_url(@kepegawaian), notice: "Kepegawaian was successfully created." }
        format.json { render :show, status: :created, location: @kepegawaian }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @kepegawaian.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kepegawaians/1 or /kepegawaians/1.json
  def update
    respond_to do |format|
      if @kepegawaian.update(kepegawaian_params)
        format.html { redirect_to kepegawaian_url(@kepegawaian), notice: "Kepegawaian was successfully updated." }
        format.json { render :show, status: :ok, location: @kepegawaian }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kepegawaian.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kepegawaians/1 or /kepegawaians/1.json
  def destroy
    @kepegawaian.destroy

    respond_to do |format|
      format.html { redirect_to kepegawaians_url, notice: "Kepegawaian was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kepegawaian
      @kepegawaian = Kepegawaian.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kepegawaian_params
      params.require(:kepegawaian).permit(:status_kepegawaian, :jumlah, :jabatan_id)
    end
end
