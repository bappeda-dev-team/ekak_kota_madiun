class PermasalahansController < ApplicationController
  before_action :set_permasalahan, only: %i[show edit update destroy]
  layout false, only: %i[edit new]

  # GET /permasalahans or /permasalahans.json
  def index
    @permasalahans = Permasalahan.all
  end

  # GET /permasalahans/1 or /permasalahans/1.json
  def show; end

  # GET /permasalahans/new
  def new
    @sasaran = Sasaran.find(params[:sasaran_id])
    @permasalahan = Permasalahan.new
  end

  # GET /permasalahans/1/edit
  def edit
    @sasaran = Sasaran.find(params[:sasaran_id])
  end

  # POST /permasalahans or /permasalahans.json
  def create
    @sasaran = Sasaran.find(params[:sasaran_id])
    @permasalahan = @sasaran.permasalahans.build(permasalahan_params)

    if @permasalahan.save
      render json: { resText: "Permaslahaan berhasil disimpan",
                     html_content: html_content({ sasaran: @sasaran,
                                                  permasalahan: @permasalahan },
                                                partial: 'permasalahans/permasalahan_card') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ sasaran: @sasaran,
                                                   permasalahan: @permasalahan },
                                                 partial: 'permasalahans/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /permasalahans/1 or /permasalahans/1.json
  def update
    @sasaran = Sasaran.find(params[:sasaran_id])
    if @permasalahan.update(permasalahan_params)
      render json: { resText: "Permaslahaan berhasil diupdate",
                     html_content: html_content({ sasaran: @sasaran,
                                                  permasalahan: @permasalahan },
                                                partial: 'permasalahans/row_permasalahan_card') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ sasaran: @sasaran,
                                                   permasalahan: @permasalahan },
                                                 partial: 'permasalahans/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /permasalahans/1 or /permasalahans/1.json
  def destroy
    @permasalahan.destroy

    render json: { resText: "Permasalahan dihapus." }.to_json,
           status: :accepted
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_permasalahan
    @permasalahan = Permasalahan.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def permasalahan_params
    params.require(:permasalahan).permit(:permasalahan, :jenis, :penyebab_internal, :penyebab_external)
  end
end
