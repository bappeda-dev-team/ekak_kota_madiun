class TematiksController < ApplicationController
  before_action :set_tematik, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /tematiks or /tematiks.json
  def index
    @tematiks = Tematik.all
  end

  # GET /tematiks/1 or /tematiks/1.json
  def show; end

  # GET /tematiks/new
  def new
    @tematik = Tematik.new
  end

  # GET /tematiks/1/edit
  def edit; end

  # POST /tematiks or /tematiks.json
  def create
    @tematik = Tematik.new(tematik_params)

    respond_to do |format|
      if @tematik.save
        format.json { render :show, status: :created, location: @tematik }
      else
        format.json { render json: @tematik.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tematiks/1 or /tematiks/1.json
  def update
    respond_to do |format|
      if @tematik.update(tematik_params)
        format.json { render :show, status: :ok, location: @tematik }
      else
        format.json { render json: @tematik.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tematiks/1 or /tematiks/1.json
  def destroy
    @tematik.destroy

    respond_to do |format|
      format.html { redirect_to tematiks_url, warning: "Tema dihapus" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tematik
    @tematik = Tematik.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tematik_params
    params.require(:tematik).permit(:tema, :keterangan, :tematik_ref_id, :type)
  end
end
