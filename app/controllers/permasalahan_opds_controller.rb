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
  def edit; end

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
    respond_to do |format|
      if @permasalahan_opd.update(permasalahan_opd_params)
        format.html do
          redirect_to permasalahan_opd_url(@permasalahan_opd), notice: "Permasalahan opd was successfully updated."
        end
        format.json { render :show, status: :ok, location: @permasalahan_opd }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @permasalahan_opd.errors, status: :unprocessable_entity }
      end
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
    params.require(:permasalahan_opd).permit(:permasalahan, :kode_opd, :tahun, :status, :isu_strategis_opd_id)
  end
end
