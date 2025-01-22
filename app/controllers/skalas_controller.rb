class SkalasController < ApplicationController
  before_action :set_skala, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /skalas or /skalas.json
  def index
    @skalas = Skala.all.order(%i[type nilai])
  end

  # GET /skalas/1 or /skalas/1.json
  def show; end

  # GET /skalas/new
  def new
    @skala = Skala.new
  end

  # GET /skalas/1/edit
  def edit; end

  # POST /skalas or /skalas.json
  def create
    @skala = Skala.new(skala_params)

    if @skala.save
      render json: { resText: 'Skala Baru berhasil disimpan.',
                     html_content: html_content({ skala: @skala },
                                                partial: 'skalas/skala') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ skala: @skala },
                                                 partial: 'skalas/form').to_json }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /skalas/1 or /skalas/1.json
  def update
    if @skala.update(skala_params)
      render json: { resText: 'Perubahan disimpan',
                     html_content: html_content({ skala: @skala },
                                                partial: 'skalas/skala') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ skala: @skala },
                                                 partial: 'skalas/form').to_json }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /skalas/1 or /skalas/1.json
  def destroy
    @skala.destroy

    render json: { resText: "Skala Dihapus" }.to_json, status: :accepted
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_skala
    @skala = Skala.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def skala_params
    params.require(:skala).permit(:type, :deskripsi, :kode_skala, :nilai, :tipe_nilai, :keterangan)
  end
end
