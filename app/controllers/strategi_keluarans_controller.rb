class StrategiKeluaransController < ApplicationController
  before_action :set_strategi_keluaran, only: %i[ show edit update destroy ]

  # GET /strategi_keluarans or /strategi_keluarans.json
  def index
    @strategi_keluarans = StrategiKeluaran.all.with_rich_text_metode.with_rich_text_tahapan
  end

  # GET /strategi_keluarans/1 or /strategi_keluarans/1.json
  def show
  end

  # GET /strategi_keluarans/new
  def new
    @strategi_keluaran = StrategiKeluaran.new
  end

  # GET /strategi_keluarans/1/edit
  def edit
  end

  # POST /strategi_keluarans or /strategi_keluarans.json
  def create
    @strategi_keluaran = StrategiKeluaran.new(strategi_keluaran_params)

    respond_to do |format|
      if @strategi_keluaran.save
        format.html { redirect_to @strategi_keluaran, notice: "Strategi keluaran was successfully created." }
        format.json { render :show, status: :created, location: @strategi_keluaran }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @strategi_keluaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /strategi_keluarans/1 or /strategi_keluarans/1.json
  def update
    respond_to do |format|
      if @strategi_keluaran.update(strategi_keluaran_params)
        format.html { redirect_to @strategi_keluaran, notice: "Strategi keluaran was successfully updated." }
        format.json { render :show, status: :ok, location: @strategi_keluaran }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @strategi_keluaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /strategi_keluarans/1 or /strategi_keluarans/1.json
  def destroy
    @strategi_keluaran.destroy
    respond_to do |format|
      format.html { redirect_to strategi_keluarans_url, notice: "Strategi keluaran was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_strategi_keluaran
      @strategi_keluaran = StrategiKeluaran.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def strategi_keluaran_params
      params.require(:strategi_keluaran).permit(:metode, :tahapan)
    end
end
