class LatarBelakangsController < ApplicationController
  before_action :set_latar_belakang, only: %i[ show edit update destroy ]

  # GET /latar_belakangs or /latar_belakangs.json
  def index
    @latar_belakangs = LatarBelakang.all.with_rich_text_dasar_hukum.with_rich_text_gambaran_umum
  end

  # GET /latar_belakangs/1 or /latar_belakangs/1.json
  def show
  end

  # GET /latar_belakangs/new
  def new
    @latar_belakang = LatarBelakang.new
  end

  # GET /latar_belakangs/1/edit
  def edit
  end

  # POST /latar_belakangs or /latar_belakangs.json
  def create
    @latar_belakang = LatarBelakang.new(latar_belakang_params)

    respond_to do |format|
      if @latar_belakang.save
        format.html { redirect_to @latar_belakang, notice: "Latar belakang was successfully created." }
        format.json { render :show, status: :created, location: @latar_belakang }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @latar_belakang.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /latar_belakangs/1 or /latar_belakangs/1.json
  def update
    respond_to do |format|
      if @latar_belakang.update(latar_belakang_params)
        format.html { redirect_to @latar_belakang, notice: "Latar belakang was successfully updated." }
        format.json { render :show, status: :ok, location: @latar_belakang }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @latar_belakang.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /latar_belakangs/1 or /latar_belakangs/1.json
  def destroy
    @latar_belakang.destroy
    respond_to do |format|
      format.html { redirect_to latar_belakangs_url, notice: "Latar belakang was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_latar_belakang
    @latar_belakang = LatarBelakang.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def latar_belakang_params
    params.require(:latar_belakang).permit(:dasar_hukum, :gambaran_umum)
  end
end
