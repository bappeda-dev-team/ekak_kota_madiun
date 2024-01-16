class PermasalahanOpdsController < ApplicationController
  before_action :set_permasalahan_opd, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /permasalahan_opds or /permasalahan_opds.json
  def index
    @permasalahan_opds = PermasalahanOpd.all
  end

  # GET /permasalahan_opds/1 or /permasalahan_opds/1.json
  def show; end

  # GET /permasalahan_opds/new
  def new
    isu_strategis_opd = params[:isu_strategis_opd_id]
    kode_opd = params[:kode_opd]
    tahun = params[:tahun]
    @permasalahan_opd = PermasalahanOpd.new(isu_strategis_opd_id: isu_strategis_opd,
                                            tahun: tahun,
                                            kode_opd: kode_opd)
  end

  # GET /permasalahan_opds/1/edit
  def edit
    @tahun = cookies[:tahun].present? ? cookies[:tahun] : Date.today.year.to_s
    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    # periode = Periode.find_tahun(tahun_bener)
    # tahun_awal = periode.tahun_awal.to_i
    # tahun_akhir = periode.tahun_akhir.to_i
    # HARD CODED FROM REQ
    tahun_awal = 2019
    tahun_akhir = 2023
    @range_tahun = tahun_akhir.downto(tahun_awal).to_a
  end

  # POST /permasalahan_opds or /permasalahan_opds.json
  def create
    @permasalahan_opd = PermasalahanOpd.new(permasalahan_opd_params)

    if @permasalahan_opd.save
      render json: { resText: "Sukses" }.to_json,
             status: :created
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /permasalahan_opds/1 or /permasalahan_opds/1.json
  def update
    if @permasalahan_opd.update(permasalahan_opd_params)
      render json: { resText: "Sukses" }.to_json,
             status: :created
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /permasalahan_opds/1 or /permasalahan_opds/1.json
  def destroy
    @permasalahan_opd.destroy

    render json: { resText: "Isu Strategis Dihapus", result: true },
           status: :accepted
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_permasalahan_opd
    @permasalahan_opd = PermasalahanOpd.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def permasalahan_opd_params
    params.require(:permasalahan_opd).permit(:permasalahan, :kode_opd, :tahun, :status, :isu_strategis_opd_id,
                                             data_dukung_attributes)
  end

  def data_dukung_attributes
    { data_dukungs_attributes: [:id, :data_dukungable_type, :data_dukungable_id,
                                :nama_data, :_destroy,
                                jumlahs_attributes] }
  end

  def jumlahs_attributes
    { jumlahs_attributes: %i[id jumlah satuan tahun _destroy] }
  end
end
