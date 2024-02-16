class KepegawaiansController < ApplicationController
  before_action :set_kepegawaian, only: %i[show edit update destroy]
  layout false, only: %i[new edit_jumlah]

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
                           .build(opd_id: @opd.id,
                                  tahun: @tahun)
  end

  # GET /kepegawaians/1/edit
  def edit; end

  def edit_jumlah
    @jabatan = Jabatan.find(params[:jabatan_id])
    @opd = Opd.find_by(kode_unik_opd: cookies[:opd])
    @tahun = cookies[:tahun]
    @status_kepegawaian = Jabatan::STATUS_KEPEGAWAIAN
    @jenis_pendidikan = Kepegawaian::JENIS_PENDIDIKAN
    @kepegawaians = @jabatan.kepegawaians.where(tahun: @tahun, opd: @opd)
  end

  def update_jumlah
    @jabatan = Jabatan.find(params[:jabatan_id])
    @status_kepegawaian = Jabatan::STATUS_KEPEGAWAIAN
    @jenis_pendidikan = Kepegawaian::JENIS_PENDIDIKAN
    @tahun = cookies[:tahun]

    status_kepegawaians = params[:status_kepegawaian]
    jumlah_kepegawaians = params[:jumlah]
    pendidikan_terakhirs = params[:pendidikan_terakhir]

    kepegawaians = status_kepegawaians.zip(jumlah_kepegawaians)

    @kepegawaians = kepegawaians.map do |status, jumlah|
      @jabatan.kepegawaians.find_by(status_kepegawaian: status).update({ jumlah: jumlah })
    end

    pendidikan_pegawai = @jabatan.pendidikan_pegawai(@tahun)
    tambah_pendidikan = pendidikan_terakhirs.difference(pendidikan_pegawai).compact_blank
    hapus_pendidikan = pendidikan_pegawai.difference(pendidikan_terakhirs).compact_blank

    @jabatan.tambah_pendidikan_kepegawaian(tambah_pendidikan) if tambah_pendidikan.any?

    @jabatan.hapus_pendidikan_kepegawaian(hapus_pendidikan) if hapus_pendidikan.any?

    if @kepegawaians.any?
      render json: { resText: 'Update berhasil',
                     html_content: html_content({ jabatan: @jabatan },
                                                partial: 'jabatans/jabatan_kepegawaian') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({},
                                                 partial: 'kepegawaians/form_edit_jumlah') }.to_json,
             status: :unprocessable_entity
    end
  end

  # POST /kepegawaians or /kepegawaians.json
  def create
    @jabatan = Jabatan.find(params[:jabatan_id])
    @status_kepegawaian = Jabatan::STATUS_KEPEGAWAIAN
    @jenis_pendidikan = Kepegawaian::JENIS_PENDIDIKAN
    @opd = Opd.find_by(kode_unik_opd: cookies[:opd])
    @tahun = cookies[:tahun]

    status_kepegawaians = params[:kepegawaian][:status_kepegawaian]
    jumlah_kepegawaians = params[:kepegawaian][:jumlah]
    pendidikan_terakhirs = params[:kepegawaian][:pendidikan_terakhir].compact_blank
    tahun = params[:kepegawaian][:tahun]
    opd = params[:kepegawaian][:opd_id]
    kepegawaians = status_kepegawaians.zip(jumlah_kepegawaians)

    @kepegawaians = kepegawaians.map do |status, jumlah|
      @jabatan.kepegawaians.create({
                                     opd_id: opd,
                                     tahun: tahun,
                                     status_kepegawaian: status,
                                     jumlah: jumlah.to_i
                                   })
    end

    if @kepegawaians.any?

      @kepegawaians.map do |kp|
        pendidikan_terakhirs.each do |pt|
          kp.pendidikan_terakhirs.create({
                                           pendidikan: pt,
                                           keterangan: '-'
                                         })
        end
      end

      render json: { resText: 'Entri Jabatan ditambahkan',
                     html_content: html_content({ jabatan: @jabatan },
                                                partial: 'jabatans/jabatan_kepegawaian') }.to_json,
             status: :ok
    else
      @kepegawaian = @jabatan.kepegawaians
                             .build(opd_id: @opd.id,
                                    tahun: @tahun)
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ jabatan: @jabatan },
                                                 partial: 'kepegawaians/form') }.to_json,
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
    params.require(:kepegawaian).permit!
  end
end
