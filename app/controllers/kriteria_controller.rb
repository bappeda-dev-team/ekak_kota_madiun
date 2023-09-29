class KriteriaController < ApplicationController
  before_action :set_kriterium, only: %i[show edit update destroy]
  layout false, only: %i[new edit edit_sub]

  # GET /kriteria or /kriteria.json
  def index
    @kriteria = Kriterium.all
  end

  # GET /kriteria/1 or /kriteria/1.json
  def show; end

  # GET /kriteria/new
  def new
    @kriterium = Kriterium.new
  end

  # GET /kriteria/1/edit
  def edit; end

  # POST /kriteria or /kriteria.json
  def create
    @kriterium = Kriterium.new(kriterium_params)

    respond_to do |format|
      if @kriterium.save
        format.html { redirect_to kriterium_url(@kriterium), notice: "Kriterium was successfully created." }
        format.json { render :show, status: :created, location: @kriterium }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @kriterium.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kriteria/1 or /kriteria/1.json
  def update
    respond_to do |format|
      if @kriterium.update(kriterium_params)
        format.html { redirect_to kriterium_url(@kriterium), notice: "Kriterium was successfully updated." }
        format.json { render :show, status: :ok, location: @kriterium }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kriterium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kriteria/1 or /kriteria/1.json
  def destroy
    @kriterium.destroy

    respond_to do |format|
      format.html { redirect_to kriteria_url, notice: "Kriterium was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_kriterium
    @kriterium = Kriterium.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def kriterium_params
    params.require(:kriterium).permit(:kriteria, :poin, :poin_max, :poin_min, :keterangan, :tipe_kriteria)
  end
end
