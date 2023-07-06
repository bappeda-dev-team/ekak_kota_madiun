class OpdBidangsController < ApplicationController
  before_action :set_opd_bidang, only: %i[show edit update destroy]

  # GET /opd_bidangs or /opd_bidangs.json
  def index
    @opd_bidangs = OpdBidang.all
  end

  # GET /opd_bidangs/1 or /opd_bidangs/1.json
  def show; end

  # GET /opd_bidangs/new
  def new
    @opd_bidang = OpdBidang.new
    render partial: 'form', locals: { opd_bidang: @opd_bidang }
  end

  # GET /opd_bidangs/1/edit
  def edit
    render partial: 'form', locals: { opd_bidang: @opd_bidang }
  end

  # POST /opd_bidangs or /opd_bidangs.json
  def create
    @opd_bidang = OpdBidang.new(opd_bidang_params)

    if @opd_bidang.save
      render json: @opd_bidang, status: :created
    else
      render json: @opd_bidang.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /opd_bidangs/1 or /opd_bidangs/1.json
  def update
    if @opd_bidang.update(opd_bidang_params)
      render json: @opd_bidang, status: :ok
    else
      render json: @opd_bidang.errors, status: :unprocessable_entity
    end
  end

  # DELETE /opd_bidangs/1 or /opd_bidangs/1.json
  def destroy
    @opd_bidang.destroy

    respond_to do |format|
      format.html { redirect_to opd_bidangs_url, warning: "Opd bidang was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_opd_bidang
    @opd_bidang = OpdBidang.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def opd_bidang_params
    params.require(:opd_bidang).permit(:nama_bidang, :opd_id, :kode_unik_opd, :kode_unik_bidang, :tahun, :nip_kepala,
                                       :pangkat_kepala, :id_daerah, :lembaga_id)
  end
end
