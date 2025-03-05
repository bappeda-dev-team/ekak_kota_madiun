class AksisController < ApplicationController
  before_action :set_sasaran
  before_action :set_aksi, only: %i[show edit update destroy]
  layout false, only: %i[edit new]

  # GET /aksis or /aksis.json
  def index
    @aksis = Aksi.all
  end

  # GET /aksis/1 or /aksis/1.json
  def show; end

  # GET /aksis/new
  def new
    # @aksi = Aksi.new
    @bulan = params[:bulan]
    id_aksi_bulan = SecureRandom.base36(6)
    @aksi = @tahapan.aksis.build(bulan: @bulan,
                                 id_aksi_bulan: id_aksi_bulan)
  end

  # GET /aksis/1/edit
  def edit
    @bulan = params[:bulan]
    @type = params[:type]
  end

  # POST /aksis or /aksis.json
  def create
    @bulan = aksi_params[:bulan]
    @aksi = Aksi.new(aksi_params)
    if @aksi.save
      render json: { resText: "Target berhasil ditambahkan.",
                     html_content: html_content({ sasaran: @sasaran,
                                                  tahapan: @tahapan,
                                                  aksi: @aksi,
                                                  bulan: @bulan },
                                                partial: 'aksis/aksi') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ sasaran: @sasaran,
                                                   tahapan: @tahapan,
                                                   aksi: @aksi,
                                                   bulan: @bulan },
                                                 partial: 'aksis/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /aksis/1 or /aksis/1.json
  def update
    @bulan = @aksi.bulan
    # @aksi.id_aksi_bulan = SecureRandom.base36(6) if @aksi.id_aksi_bulan.nil?
    if @aksi.update(aksi_params)
      render json: { resText: "Target berhasil ditambahkan.",
                     html_content: html_content({ sasaran: @sasaran,
                                                  tahapan: @tahapan,
                                                  aksi: @aksi,
                                                  bulan: @bulan },
                                                partial: 'aksis/aksi') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ sasaran: @sasaran,
                                                   tahapan: @tahapan,
                                                   aksi: @aksi,
                                                   bulan: @bulan },
                                                 partial: 'aksis/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /aksis/1 or /aksis/1.json
  def destroy
    @aksi.destroy
    respond_to do |format|
      format.html { redirect_to sasaran_path(@sasaran), notice: 'Aksi was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sasaran
    @sasaran = Sasaran.find(params[:sasaran_id])
    @tahapan = @sasaran.tahapans.find(params[:tahapan_id])
  end

  def set_aksi
    @aksi = Aksi.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def aksi_params
    params.require(:aksi).permit(:target, :bulan,
                                 :id_rencana_aksi, :id_aksi_bulan)
  end
end
