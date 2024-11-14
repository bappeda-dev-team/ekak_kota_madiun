class AkarMasalahsController < ApplicationController
  before_action :set_akar_masalah, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /akar_masalahs or /akar_masalahs.json
  def index
    @akar_masalahs = AkarMasalah.all
  end

  # GET /akar_masalahs/new
  def new
    # @akar_masalah = AkarMasalah.new
    @jenis = params[:jenis]
    @rowspan = params[:rowspan]
    @strategi_id = params[:strategi_id]
    @strategi = Strategi.find(@strategi_id)
    @akar_masalah = AkarMasalah.new(jenis: @jenis, masalah: @strategi.strategi)
  end

  # GET /akar_masalahs/1/edit
  def edit; end

  # POST /akar_masalahs or /akar_masalahs.json
  def create
    @akar_masalah = AkarMasalah.new(akar_masalah_params)

    respond_to do |format|
      if @akar_masalah.save
        format.html { redirect_to akar_masalah_url(@akar_masalah), notice: "Akar masalah was successfully created." }
        format.json { render :show, status: :created, location: @akar_masalah }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @akar_masalah.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /akar_masalahs/1 or /akar_masalahs/1.json
  def update
    respond_to do |format|
      if @akar_masalah.update(akar_masalah_params)
        format.html { redirect_to akar_masalah_url(@akar_masalah), notice: "Akar masalah was successfully updated." }
        format.json { render :show, status: :ok, location: @akar_masalah }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @akar_masalah.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /akar_masalahs/1 or /akar_masalahs/1.json
  def destroy
    @akar_masalah.destroy

    respond_to do |format|
      format.html { redirect_to akar_masalahs_url, notice: "Akar masalah was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_akar_masalah
    @akar_masalah = AkarMasalah.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def akar_masalah_params
    params.fetch(:akar_masalah, {})
  end
end
