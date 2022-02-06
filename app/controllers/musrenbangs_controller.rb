class MusrenbangsController < ApplicationController
  before_action :set_musrenbang, only: %i[ show edit update destroy ]

  # GET /musrenbangs or /musrenbangs.json
  def index
    @musrenbangs = Musrenbang.all
  end

  # GET /musrenbangs/1 or /musrenbangs/1.json
  def show
  end

  # GET /musrenbangs/new
  def new
    @musrenbang = Musrenbang.new
  end

  # GET /musrenbangs/1/edit
  def edit
  end

  # POST /musrenbangs or /musrenbangs.json
  def create
    @musrenbang = Musrenbang.new(musrenbang_params)

    respond_to do |format|
      if @musrenbang.save
        format.html { redirect_to @musrenbang, notice: "Musrenbang was successfully created." }
        format.json { render :show, status: :created, location: @musrenbang }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @musrenbang.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /musrenbangs/1 or /musrenbangs/1.json
  def update
    respond_to do |format|
      if @musrenbang.update(musrenbang_params)
        format.html { redirect_to @musrenbang, notice: "Musrenbang was successfully updated." }
        format.json { render :show, status: :ok, location: @musrenbang }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @musrenbang.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /musrenbangs/1 or /musrenbangs/1.json
  def destroy
    @musrenbang.destroy
    respond_to do |format|
      format.html { redirect_to musrenbangs_url, notice: "Musrenbang was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_musrenbang
      @musrenbang = Musrenbang.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def musrenbang_params
      params.require(:musrenbang).permit(:usulan, :tahun)
    end
end
