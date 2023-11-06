class KomentarsController < ApplicationController
  before_action :set_komentar, only: %i[show edit update destroy]

  # GET /komentars or /komentars.json
  def index
    @komentars = Komentar.all
  end

  # GET /komentars/1 or /komentars/1.json
  def show; end

  # GET /komentars/new
  def new
    @komentar = Komentar.new
  end

  def komentar_pokin
    @komentar = Komentar.new
    @kode_opd = params[:kode_opd]
    @strategi_id = params[:strategi_id]
    @jenis = params[:jenis]
    render partial: "form_komentar_pokin", locals: { komentar: @komentar }
  end

  # GET /komentars/1/edit
  def edit; end

  # POST /komentars or /komentars.json
  def create
    @komentar = Komentar.new(komentar_params)

    if @komentar.save
      render json: { resText: "Review ditambahkan",
                     html_content: html_content({ komentar: @komentar },
                                                partial: 'komentars/komentar') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan",
                     html_content: error_content({ komentar: @komentar },
                                                 partial: 'komentars/form_komentar_pokin') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /komentars/1 or /komentars/1.json
  def update
    respond_to do |format|
      if @komentar.update(komentar_params)
        format.js
        format.html { redirect_to komentar_url(@komentar), notice: "Komentar was successfully updated." }
        format.json { render :show, status: :ok, location: @komentar }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @komentar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /komentars/1 or /komentars/1.json
  def destroy
    @komentar.destroy

    respond_to do |format|
      format.html { redirect_to komentars_url, notice: "Komentar was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_komentar
    @komentar = Komentar.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def komentar_params
    params.require(:komentar).permit(:judul, :komentar, :kode_opd, :user_id, :item, :jenis)
  end
end
