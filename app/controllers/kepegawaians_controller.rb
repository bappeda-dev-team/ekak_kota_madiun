class KepegawaiansController < ApplicationController
  before_action :set_kepegawaian, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /kepegawaians or /kepegawaians.json
  def index
    @kepegawaians = Kepegawaian.all
  end

  # GET /kepegawaians/1 or /kepegawaians/1.json
  def show; end

  # GET /kepegawaians/new
  def new
    @jabatan = Jabatan.find(params[:jabatan_id])
    @opd = Opd.find_by(kode_unik_opd: cookies[:opd])
    @tahun = cookies[:tahun]

    @status_kepegawaian = Jabatan::STATUS_KEPEGAWAIAN
    @jenis_pendidikan = Kepegawaian::JENIS_PENDIDIKAN

    @kepegawaian = @jabatan.kepegawaians
                           .build(opd: @opd,
                                  tahun: @tahun)
  end

  # GET /kepegawaians/1/edit
  def edit; end

  # POST /kepegawaians or /kepegawaians.json
  def create
    @kepegawaian = Kepegawaian.new(kepegawaian_params)

    if @kepegawaian.save
      render json: { resText: 'Entri Jabatan ditambahkan',
                     html_content: html_content({ jabatan: @kepegawaian },
                                                partial: 'kepegawaians/kepegawaian') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ jabatan: @kepegawaian },
                                                 partial: 'kepegawaians/form').to_json }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /kepegawaians/1 or /kepegawaians/1.json
  def update
    respond_to do |format|
      if @kepegawaian.update(kepegawaian_params)
        format.html { redirect_to kepegawaian_url(@kepegawaian), notice: "Kepegawaian was successfully updated." }
        format.json { render :show, status: :ok, location: @kepegawaian }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kepegawaian.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kepegawaians/1 or /kepegawaians/1.json
  def destroy
    @kepegawaian.destroy

    respond_to do |format|
      format.html { redirect_to kepegawaians_url, notice: "Kepegawaian was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_kepegawaian
    @kepegawaian = Kepegawaian.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def kepegawaian_params
    params.require(:kepegawaian).permit(:status_kepegawaian, :jumlah, :jabatan_id)
  end
end
