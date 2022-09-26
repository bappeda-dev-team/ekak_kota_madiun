class DampaksController < ApplicationController
  before_action :set_dampak, only: %i[show edit update destroy]

  # GET /dampaks or /dampaks.json
  def index
    @dampaks = Dampak.all
  end

  # GET /dampaks/1 or /dampaks/1.json
  def show; end

  # GET /dampaks/new
  def new
    @dampak = Dampak.new
  end

  # GET /dampaks/1/edit
  def edit; end

  # POST /dampaks or /dampaks.json
  def create
    @dampak = Dampak.new(dampak_params)

    respond_to do |format|
      if @dampak.save
        format.html { redirect_to dampak_url(@dampak), notice: "Dampak was successfully created." }
        format.json { render :show, status: :created, location: @dampak }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dampak.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dampaks/1 or /dampaks/1.json
  def update
    respond_to do |format|
      if @dampak.update(dampak_params)
        format.html { redirect_to dampak_url(@dampak), notice: "Dampak was successfully updated." }
        format.json { render :show, status: :ok, location: @dampak }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dampak.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dampaks/1 or /dampaks/1.json
  def destroy
    @dampak.destroy

    respond_to do |format|
      format.html { redirect_to dampaks_url, notice: "Dampak was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dampak
    @dampak = Dampak.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def dampak_params
    params.require(:dampak).permit(:type, :deskripsi, :kode_skala, :nilai, :tipe_nilai, :keterangan)
  end
end
