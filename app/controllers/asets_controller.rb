class AsetsController < ApplicationController
  before_action :set_aset, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /asets or /asets.json
  def index
    @asets = Aset.all
  end

  # GET /asets/1 or /asets/1.json
  def show; end

  # GET /asets/new
  def new
    @tahun = cookies[:tahun]
    @opd = Opd.find_by(kode_unik_opd: cookies[:opd])
    @count = (SecureRandom.random_number(9e5) + 1e5).to_i
    @aset = Aset.new(opd: @opd, tahun_akhir: @tahun)
    @kondisi_aset = Aset::KONDISI_ASET
  end

  # GET /asets/1/edit
  def edit
    @tahun = cookies[:tahun]
    @count = (SecureRandom.random_number(9e5) + 1e5).to_i
    @kondisi_aset = Aset::KONDISI_ASET
  end

  # POST /asets or /asets.json
  def create
    @kondisi_aset = Aset::KONDISI_ASET
    @aset = Aset.new(aset_params)

    if @aset.save
      render json: { resText: 'Aset OPD ditambahkan',
                     html_content: html_content({ aset: @aset },
                                                partial: 'asets/aset') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ aset: @aset },
                                                 partial: 'asets/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /asets/1 or /asets/1.json
  def update
    @kondisi_aset = Aset::KONDISI_ASET
    if @aset.update(aset_params)
      render json: { resText: 'Perubahan data disimpan',
                     html_content: html_content({ aset: @aset },
                                                partial: 'asets/aset') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ aset: @aset },
                                                 partial: 'asets/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /asets/1 or /asets/1.json
  def destroy
    @aset.destroy

    respond_to do |format|
      format.html { redirect_to asets_url, notice: "Aset was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_aset
    @aset = Aset.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def aset_params
    params.require(:aset).permit(:nama_aset, :jumlah,
                                 :satuan, :tahun_awal, :tahun_akhir,
                                 :keterangan, :kode_unik_opd, kondisi: [],
                                                              tahun_aset: [])
  end
end
