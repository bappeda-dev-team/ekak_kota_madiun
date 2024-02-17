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
    setup_jabatan
    @jabatan = Jabatan.new(kode_opd: @opd.kode_unik_opd, tahun: @tahun)
    @jabatan.kepegawaians.build(tahun: @tahun, opd: @opd, status_kepegawaian: '', jumlah: 0)
            .pendidikan_terakhirs.build
  end

  # GET /jabatans/1/edit
  def edit; end

  # POST /jabatans or /jabatans.json
  def create
    setup_jabatan
    pendidikan = params[:pendidikan]
    @jabatan = Jabatan.new(jabatan_params)

    if @jabatan.save

      pendidikan.each do |pend|
        @jabatan.kepegawaians.first
                .pendidikan_terakhirs.create(pendidikan: pend)
      end

      render json: { resText: 'Jabatan ditambahkan',
                     html_content: html_content({ jabatan: @jabatan },
                                                partial: 'jabatans/jabatan_kepegawaian') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ jabatan: @jabatan },
                                                 partial: 'jabatans/form_row') }.to_json,
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

  def setup_jabatan
    @count = (SecureRandom.random_number(9e5) + 1e5).to_i
    @opd = Opd.find_by(kode_unik_opd: cookies[:opd])
    @tahun = cookies[:tahun]
    @status_kepegawaian = Jabatan::STATUS_KEPEGAWAIAN
    @jenis_pendidikan = Kepegawaian::JENIS_PENDIDIKAN
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_jabatan
    @jabatan = Jabatan.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def jabatan_params
    params.require(:jabatan).permit(:nama_jabatan, :kelas_jabatan, :nilai_jabatan, :index, :kode_opd, :tipe,
                                    :id_jabatan, :tahun, :jenis_jabatan_id,
                                    kepegawaians_attributes: kepegawaian_params)
  end

  def kepegawaian_params
    [:id, :tahun, :jumlah, :opd_id,
     :status_kepegawaian, { pendidikan_terakhirs_attributes: pendidikan_params }]
  end

  def pendidikan_params
    %i[id pendidikan]
  end
end
