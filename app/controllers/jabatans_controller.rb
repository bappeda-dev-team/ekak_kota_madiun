class JabatansController < ApplicationController
  before_action :set_jabatan, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /jabatans or /jabatans.json
  def index
    @tahun_asli = cookies[:tahun]
    @tahun = @tahun_asli&.gsub('_perubahan', '')
    @kode_opd = cookies[:opd]
    @jabatans = Jabatan.where(tahun: @tahun)
  end

  # GET /jabatans/1 or /jabatans/1.json
  def show; end

  # GET /jabatans/new
  def new
    @opd = Opd.find_by(kode_unik_opd: cookies[:opd])
    @tahun = cookies[:tahun]
    @jabatan = Jabatan.new
    @status_kepegawaian = Jabatan::STATUS_KEPEGAWAIAN
    @jenis_pendidikan = Kepegawaian::JENIS_PENDIDIKAN
  end

  # GET /jabatans/1/edit
  def edit; end

  # POST /jabatans or /jabatans.json
  def create
    @jabatan = Jabatan.new(jabatan_params)

    if @jabatan.save
      render json: { resText: 'Entri Jabatan ditambahkan',
                     html_content: html_content({ jabatan: @jabatan },
                                                partial: 'jabatans/jabatan') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ jabatan: @jabatan },
                                                 partial: 'jabatans/form').to_json }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /jabatans/1 or /jabatans/1.json
  def update
    if @jabatan.update(jabatan_params)
      render json: { resText: 'Perubahan tersimpan',
                     html_content: html_content({ jabatan: @jabatan },
                                                partial: 'jabatans/jabatan') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ jabatan: @jabatan },
                                                 partial: 'jabatans/form').to_json }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /jabatans/1 or /jabatans/1.json
  def destroy
    @jabatan.destroy

    respond_to do |format|
      format.html { redirect_to jabatans_url, notice: "Jabatan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_jabatan
    @jabatan = Jabatan.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def jabatan_params
    params.require(:jabatan).permit(:nama_jabatan, :kelas_jabatan, :nilai_jabatan, :index, :kode_opd, :tipe,
                                    :id_jabatan, :tahun)
  end
end
