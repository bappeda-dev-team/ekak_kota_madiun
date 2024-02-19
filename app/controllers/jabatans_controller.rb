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
  def edit
    setup_jabatan
    @kepegawaians = @jabatan.kepegawaians.where(tahun: @tahun, opd: @opd)
  end

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
    @kepegawaians = @jabatan.kepegawaians.where(tahun: @tahun, opd: @opd)
    setup_jabatan
    if @jabatan.update(jabatan_params)
      update_jumlah_kepegawaian_jabatan
      update_pendidikan_jabatan

      render json: { resText: 'Perubahan tersimpan',
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
    %i[id tahun jumlah opd_id
       status_kepegawaian]
  end

  def pendidikan_params
    %i[id pendidikan]
  end

  def update_pendidikan_jabatan
    pendidikan = params[:pendidikan]
    pendidikan_pegawai = @jabatan.pendidikan_pegawai(@tahun)
    tambah_pendidikan = pendidikan.difference(pendidikan_pegawai).compact_blank
    hapus_pendidikan = pendidikan_pegawai.difference(pendidikan).compact_blank

    @jabatan.tambah_pendidikan_kepegawaian(tambah_pendidikan) if tambah_pendidikan.any?

    @jabatan.hapus_pendidikan_kepegawaian(hapus_pendidikan) if hapus_pendidikan.any?
  end

  def update_jumlah_kepegawaian_jabatan
    status_kepegawaians = params[:status_kepegawaian]
    jumlah_kepegawaians = params[:jumlah]
    kepegawaians = status_kepegawaians.zip(jumlah_kepegawaians)

    @kepegawaians = kepegawaians.map do |status, jumlah|
      @jabatan.update_jumlah_kepegawaian(@tahun, status, jumlah)
    end
  end
end
