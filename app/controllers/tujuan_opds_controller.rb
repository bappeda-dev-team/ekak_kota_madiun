class TujuanOpdsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_tujuan_opd, only: %i[show edit update destroy]

  # GET /tujuan_opds or /tujuan_opds.json
  def index
    @opd = current_user.opd
    @nama_opd = @opd.nama_opd
    @tujuan_opds = @opd.tujuan_opds.includes(%i[indikators urusan])
  end

  # GET /tujuan_opds/1 or /tujuan_opds/1.json
  def show; end

  # GET /tujuan_opds/new
  def new
    opd_collections
    @tujuan_opd = TujuanOpd.new
  end

  # GET /tujuan_opds/1/edit
  def edit
    opd_collections
  end

  # POST /tujuan_opds or /tujuan_opds.json
  def create
    @tujuan_opd = TujuanOpd.new(tujuan_opd_params)

    respond_to do |format|
      if @tujuan_opd.save
        format.html { redirect_to tujuan_opds_url, notice: "Sukses" }
        format.json { render :show, status: :created, location: @tujuan_opd }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tujuan_opd.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tujuan_opds/1 or /tujuan_opds/1.json
  def update
    respond_to do |format|
      if @tujuan_opd.update(tujuan_opd_params)
        format.html { redirect_to tujuan_opds_url, notice: "Sukses" }
        format.json { render :show, status: :ok, location: @tujuan_opd }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tujuan_opd.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tujuan_opds/1 or /tujuan_opds/1.json
  def destroy
    @tujuan_opd.destroy

    respond_to do |format|
      format.html { redirect_to tujuan_opds_url, notice: "Tujuan opd dihapus" }
      format.json { head :no_content }
    end
  end

  def admin_filter
    @kode_opd = params[:kode_opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @tujuan_opds = @opd.tujuan_opds
    render partial: 'tujuan_opds/tujuan_opd'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tujuan_opd
    @tujuan_opd = TujuanOpd.find(params[:id])
  end

  def opd_collections
    @opds = Opd.where.not(kode_opd: nil)
               .where(kode_opd: current_user.kode_opd).pluck(:nama_opd,
                                                             :kode_unik_opd)
  end

  # Only allow a list of trusted parameters through.
  def tujuan_opd_params
    params.require(:tujuan_opd).permit(:tujuan, :id_tujuan, :kode_unik_opd, :tahun_awal, :tahun_akhir, :urusan_id,
                                       indikators_attributes)
  end

  def indikators_attributes
    { indikators_attributes: %i[id kode kode_opd indikator target satuan tahun _destroy] }
  end
end
