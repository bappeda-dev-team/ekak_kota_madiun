class DampaksController < ApplicationController
  before_action :set_dampak, only: %i[show edit update destroy]

  # GET /dampaks or /dampaks.json
  def index
    @dampaks = Dampak.all.order('nilai ASC')
  end

  # GET /dampaks/1 or /dampaks/1.json
  def show; end

  # GET /dampaks/new
  def new
    @dampak = Dampak.new
  end

  # GET /dampaks/1/edit
  def edit; end

  # POST /dampaks or /dampaks.json
  def create
    @dampak = Dampak.new(dampak_params)

    if @dampak.save
      render json: { resText: 'Dampak Baru berhasil disimpan.',
                     html_content: html_content({ skala: @dampak },
                                                partial: 'skalas/skala') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ skala: @dampak },
                                                 partial: 'skalas/form').to_json }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /dampaks/1 or /dampaks/1.json
  def update
    if @dampak.update(dampak_params)
      render json: { resText: 'Perubahan Dampak disimpan',
                     html_content: html_content({ skala: @dampak },
                                                partial: 'skalas/skala') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ skala: @dampak },
                                                 partial: 'skalas/form').to_json }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /dampaks/1 or /dampaks/1.json
  def destroy
    @dampak.destroy

    render json: { resText: "Skala Dampak Dihapus" }.to_json, status: :accepted
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dampak
    @dampak = Dampak.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def dampak_params
    params.require(:dampak).permit(:type, :deskripsi, :kode_skala, :nilai, :tipe_nilai, :keterangan)
  end
end
