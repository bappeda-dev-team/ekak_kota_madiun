class SkalasController < ApplicationController
  before_action :set_skala, only: %i[show edit update destroy]

  # GET /skalas or /skalas.json
  def index
    @skalas = Skala.all.order(:nilai)
  end

  # GET /skalas/1 or /skalas/1.json
  def show; end

  # GET /skalas/new
  def new
    @skala = Skala.new
  end

  # GET /skalas/1/edit
  def edit
    respond_to { |f| f.js { render :new } }
  end

  # POST /skalas or /skalas.json
  def create
    @skala = Skala.new(skala_params)

    respond_to do |format|
      if @skala.save
        format.html { redirect_to skala_url(@skala), notice: "Skala was successfully created." }
        format.js { redirect_to skalas_url, success: "Skala telah berhasil dibuat" }
        format.json { render :show, status: :created, location: @skala }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js { redirect_to skalas_url, status: :unprocessable_entity }
        format.json { render json: @skala.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /skalas/1 or /skalas/1.json
  def update
    respond_to do |format|
      if @skala.update(skala_params)
        format.html { redirect_to skala_url(@skala), notice: "Skala was successfully updated." }
        format.json { render :show, status: :ok, location: @skala }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @skala.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skalas/1 or /skalas/1.json
  def destroy
    @skala.destroy

    respond_to do |format|
      format.html { redirect_to skalas_url, notice: "Skala was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_skala
    @skala = Skala.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def skala_params
    params.require(:skala).permit(:type, :deskripsi, :kode_skala, :nilai, :tipe_nilai, :keterangan)
  end
end
