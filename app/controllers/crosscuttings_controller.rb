class CrosscuttingsController < ApplicationController
  before_action :set_crosscutting, only: %i[show edit update destroy]
  before_action :set_tahun_opd

  layout false

  # GET /crosscuttings or /crosscuttings.json
  def index; end

  # GET /crosscuttings/1 or /crosscuttings/1.json
  def show
    @crosscuttings = @crosscutting.external
  end

  # GET /crosscuttings/new
  def new
    @crosscutting = Crosscutting.new
  end

  # GET /crosscuttings/1/edit
  def edit; end

  # POST /crosscuttings or /crosscuttings.json
  def create
    @crosscutting = Crosscutting.new(crosscutting_params)

    respond_to do |format|
      if @crosscutting.save
        format.html { redirect_to crosscutting_url(@crosscutting), notice: "Crosscutting was successfully created." }
        format.json { render :show, status: :created, location: @crosscutting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @crosscutting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crosscuttings/1 or /crosscuttings/1.json
  def update
    respond_to do |format|
      if @crosscutting.update(crosscutting_params)
        format.html { redirect_to crosscutting_url(@crosscutting), notice: "Crosscutting was successfully updated." }
        format.json { render :show, status: :ok, location: @crosscutting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @crosscutting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crosscuttings/1 or /crosscuttings/1.json
  def destroy
    @crosscutting.destroy

    respond_to do |format|
      format.html { redirect_to crosscuttings_url, notice: "Crosscutting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_tahun_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_crosscutting
    @crosscutting = Crosscutting.new(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def crosscutting_params
    params.require(:crosscutting).permit(:internal_external, :opd_list, :keterangan)
  end
end
