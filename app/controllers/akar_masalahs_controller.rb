class AkarMasalahsController < ApplicationController
  before_action :set_akar_masalah, only: %i[show edit update destroy pilih_masalah]
  layout false, only: %i[new edit]

  # GET /akar_masalahs or /akar_masalahs.json
  def index
    @akar_masalahs = AkarMasalah.all
  end

  # GET /akar_masalahs/new
  def new
    @jenis = params[:jenis]
    @rowspan = params[:rowspan]
    @strategi_id = params[:strategi_id]
    @strategi = Strategi.find(@strategi_id)
    @kode_opd = @strategi.opd.kode_unik_opd
    @tahun = @strategi.tahun
    @akar_masalah = AkarMasalah.new(jenis: @jenis,
                                    masalah: @strategi.strategi,
                                    strategi_id: @strategi.id,
                                    kode_opd: @kode_opd,
                                    tahun: @tahun)
  end

  # GET /akar_masalahs/1/edit
  def edit
    @rowspan = params[:rowspan]
  end

  # POST /akar_masalahs or /akar_masalahs.json
  def create
    @akar_masalah = AkarMasalah.new(akar_masalah_params)

    if @akar_masalah.save
      render json: { resText: 'Masalah Disimpan',
                     html_content: html_content({ akar_masalah: @akar_masalah },
                                                partial: 'akar_masalahs/akar_masalah') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ akar_masalah: @akar_masalah },
                                                 partial: 'akar_masalahs/form_col') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /akar_masalahs/1 or /akar_masalahs/1.json
  def update
    if @akar_masalah.update(akar_masalah_params)
      render json: { resText: 'Masalah Disimpan',
                     html_content: html_content({ akar_masalah: @akar_masalah },
                                                partial: 'akar_masalahs/akar_masalah') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ akar_masalah: @akar_masalah },
                                                 partial: 'akar_masalahs/form_col') }.to_json,
             status: :unprocessable_entity
    end
  end

  def pilih_masalah
    if @akar_masalah.update(terpilih: true)
      render json: { resText: 'Masalah dipilih',
                     html_content: html_content({ akar_masalah: @akar_masalah },
                                                partial: 'akar_masalahs/akar_masalah') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ akar_masalah: @akar_masalah },
                                                 partial: 'akar_masalahs/akar_masalah') }.to_json,
             status: :unprocessable_entity
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
    params.require(:akar_masalah).permit(:jenis, :masalah, :strategi_id, :tahun, :kode_opd)
  end
end
