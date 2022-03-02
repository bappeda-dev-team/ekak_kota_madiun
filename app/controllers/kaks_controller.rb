class KaksController < ApplicationController
  before_action :set_kak, only: %i[ show edit update destroy ]

  # GET /kaks or /kaks.json
  def index
    @kaks = Kak.all
  end

  # GET /kaks/1 or /kaks/1.json
  def show
  end

  def laporan_kak
    @kaks = Kak.includes(:program_kegiatan).where.not(program_kegiatan: { id: nil })
  end

  # GET /kaks/new
  def new
    @kak = Kak.new
  end

  # GET /kaks/1/edit
  def edit
  end

  # POST /kaks or /kaks.json
  def create
    @kak = Kak.new(kak_params)

    respond_to do |format|
      if @kak.save
        format.html { redirect_to kaks_path, notice: "Kak was successfully created." }
        format.json { render :show, status: :created, location: @kak }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @kak.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kaks/1 or /kaks/1.json
  def update
    respond_to do |format|
      if @kak.update(kak_params)
        format.html { redirect_to kaks_path, notice: "Kak was successfully updated." }
        format.json { render :show, status: :ok, location: @kak }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kak.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kaks/1 or /kaks/1.json
  def destroy
    @kak.destroy
    respond_to do |format|
      format.html { redirect_to kaks_path, notice: "Kak was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_kak
    @kak = Kak.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def kak_params
    params.require(:kak).permit({ :dasar_hukum => [] },
                                :gambaran_umum,
                                :metode_pelaksanaan,
                                :penerima_manfaat,
                                :tahapan_pelaksanaan,
                                :waktu_dibutuhkan, :program_kegiatan_id)
  end
end
