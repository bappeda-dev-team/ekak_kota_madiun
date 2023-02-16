class StrategisController < ApplicationController
  before_action :set_strategi, only: %i[ show edit update destroy ]

  # GET /strategis or /strategis.json
  def index
    @strategis = Strategi.all
  end

  # GET /strategis/1 or /strategis/1.json
  def show
  end

  # GET /strategis/new
  def new
    @strategi = Strategi.new
  end

  # GET /strategis/1/edit
  def edit
  end

  # POST /strategis or /strategis.json
  def create
    @strategi = Strategi.new(strategi_params)

    respond_to do |format|
      if @strategi.save
        format.html { redirect_to strategi_url(@strategi), notice: "Strategi was successfully created." }
        format.json { render :show, status: :created, location: @strategi }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @strategi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /strategis/1 or /strategis/1.json
  def update
    respond_to do |format|
      if @strategi.update(strategi_params)
        format.html { redirect_to strategi_url(@strategi), notice: "Strategi was successfully updated." }
        format.json { render :show, status: :ok, location: @strategi }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @strategi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /strategis/1 or /strategis/1.json
  def destroy
    @strategi.destroy

    respond_to do |format|
      format.html { redirect_to strategis_url, notice: "Strategi was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_strategi
      @strategi = Strategi.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def strategi_params
      params.require(:strategi).permit(:strategi, :tahun, :sasaran_id, :strategi_ref_id, :nip_asn)
    end
end
