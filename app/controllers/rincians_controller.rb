class RinciansController < ApplicationController
  before_action :my_sasaran, only: %i[index new create update show edit subkegiatan sasaran]
  before_action :set_rincian, only: %i[show edit update destroy]
  before_action :set_dropdown, only: %i[new edit]
  layout false, only: %i[show new edit]

  # GET /rincians or /rincians.json
  def index
    @rincians = @sasaran.rincian
  end

  # GET /rincians/1 or /rincians/1.json
  def show; end

  # GET /rincians/new
  def new
    @rincian = Rincian.new
  end

  def subkegiatan
    @rincian = Rincian.new
    @jenis = 'subkegiatan'
    render :new
  end

  # GET /rincians/1/edit
  def edit; end

  # POST /rincians or /rincians.json
  def create
    @rincian = Rincian.new(rincian_params)
    jenis_layanan = params[:rincian][:jenis_layanan]
    penerima_manfaat = params[:rincian][:penerima_manfaat]
    sasaran = Sasaran.find(params[:sasaran_id])
    sasaran.update(penerima_manfaat: penerima_manfaat, jenis_layanan: jenis_layanan)

    if @rincian.save
      render json: { resText: "Rincian saaran berhasil disimpan.",
                     html_content: html_content({ sasaran: sasaran },
                                                partial: 'rincians/rincian_card') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ rincian: @rincian },
                                                 partial: 'rincians/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rincians/1 or /rincians/1.json
  def update
    jenis_layanan = params[:rincian][:jenis_layanan]
    penerima_manfaat = params[:rincian][:penerima_manfaat]
    sasaran = Sasaran.find(params[:sasaran_id])
    sasaran.update(penerima_manfaat: penerima_manfaat, jenis_layanan: jenis_layanan)

    if @rincian.update(rincian_params)
      render json: { resText: "Rincian saaran berhasil disimpan.",
                     html_content: html_content({ sasaran: sasaran },
                                                partial: 'rincians/rincian_card') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ rincian: @rincian },
                                                 partial: 'rincians/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /rincians/1 or /rincians/1.json
  def destroy
    @rincian.destroy
    respond_to do |format|
      format.html do
        redirect_to user_sasaran_path(current_user, @sasaran), success: 'Rincian dihapus.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def my_sasaran
    @sasaran = Sasaran.find(params[:sasaran_id])
  end

  def set_rincian
    @rincian = Rincian.find(params[:id])
  end

  def set_dropdown
    @sasarans = Sasaran.all
  end

  # Only allow a list of trusted parameters through.
  def rincian_params
    params.require(:rincian).permit(:data_terpilah, :penyebab_internal, :penyebab_external, :permasalahan_umum,
                                    :permasalahan_gender, :resiko, :lokasi_pelaksanaan, :dampak, :sasaran_id,
                                    :model_layanan, :jalur_layanan,
                                    :skala_id, :kemungkinan_id)
  end
end
