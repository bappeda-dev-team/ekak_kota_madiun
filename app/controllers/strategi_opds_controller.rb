class StrategiOpdsController < ApplicationController
  before_action :set_strategi_opd, only: %i[ show edit update destroy ]

  # GET /strategi_opds or /strategi_opds.json
  def index
    @strategi_opds = StrategiOpd.all
  end

  # GET /strategi_opds/1 or /strategi_opds/1.json
  def show
  end

  # GET /strategi_opds/new
  def new
    @strategi_opd = StrategiOpd.new
  end

  # GET /strategi_opds/1/edit
  def edit
  end

  # POST /strategi_opds or /strategi_opds.json
  def create
    @strategi_opd = StrategiOpd.new(strategi_opd_params)

    respond_to do |format|
      if @strategi_opd.save
        format.html { redirect_to strategi_opd_url(@strategi_opd), notice: "Strategi opd was successfully created." }
        format.json { render :show, status: :created, location: @strategi_opd }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @strategi_opd.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /strategi_opds/1 or /strategi_opds/1.json
  def update
    respond_to do |format|
      if @strategi_opd.update(strategi_opd_params)
        format.html { redirect_to strategi_opd_url(@strategi_opd), notice: "Strategi opd was successfully updated." }
        format.json { render :show, status: :ok, location: @strategi_opd }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @strategi_opd.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /strategi_opds/1 or /strategi_opds/1.json
  def destroy
    @strategi_opd.destroy

    respond_to do |format|
      format.html { redirect_to strategi_opds_url, notice: "Strategi opd was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_strategi_opd
      @strategi_opd = StrategiOpd.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def strategi_opd_params
      params.require(:strategi_opd).permit(:strategi, :tahun, :sasaran_opd_id, :isu_strategis_opd_id, :opd_id)
    end
end
