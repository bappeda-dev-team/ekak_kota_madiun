class KemungkinansController < ApplicationController
  before_action :set_kemungkinan, only: %i[show edit update destroy]

  # GET /kemungkinans or /kemungkinans.json
  def index
    @kemungkinans = Kemungkinan.all.order('nilai ASC')
  end

  # GET /kemungkinans/1 or /kemungkinans/1.json
  def show; end

  # GET /kemungkinans/new
  def new
    @kemungkinan = Kemungkinan.new
  end

  # GET /kemungkinans/1/edit
  def edit; end

  # POST /kemungkinans or /kemungkinans.json
  def create
    @kemungkinan = Kemungkinan.new(kemungkinan_params)

    if @kemungkinan.save
      render json: { resText: 'Kemungkinan Baru berhasil disimpan.',
                     html_content: html_content({ skala: @kemungkinan },
                                                partial: 'skalas/skala') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ skala: @kemungkinan },
                                                 partial: 'skalas/form').to_json }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /kemungkinans/1 or /kemungkinans/1.json
  def update
    if @kemungkinan.update(kemungkinan_params)
      render json: { resText: 'Perubahan Kemungkinan disimpan',
                     html_content: html_content({ skala: @kemungkinan },
                                                partial: 'skalas/skala') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ skala: @kemungkinan },
                                                 partial: 'skalas/form').to_json }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /kemungkinans/1 or /kemungkinans/1.json
  def destroy
    @kemungkinan.destroy

    render json: { resText: "Skala Kemungkinan Dihapus" }.to_json, status: :accepted
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_kemungkinan
    @kemungkinan = Kemungkinan.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def kemungkinan_params
    params.fetch(:kemungkinan).permit(:deskripsi, :keterangan, :kode_skala, :nilai, :tipe_nilai, :type)
  end
end
