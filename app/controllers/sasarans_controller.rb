class SasaransController < ApplicationController
  before_action :set_user, only: %i[index new anggaran]
  before_action :set_sasaran,
                only: %i[show edit update destroy update_program_kegiatan renaksi_update detail review rincian]
  before_action :set_dropdown, only: %i[new edit]

  # GET /sasarans or /sasarans.json
  def index
    @tahun = cookies[:tahun]
    kak = KakQueries.new(opd: @user.opd, tahun: @tahun, user: @user)
    @sasarans = kak.sasarans
  end

  def rekap_sasaran
    @tahun = params[:tahun]
    @nip_asn = params[:nip_asn]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd) || current_user.opd
    @user = User.find_by(nik: @nip_asn) || current_user
    @sasarans = @user.subkegiatan_sasarans_all_tahun(@tahun)
  end

  def anggaran
    @tahun = cookies[:tahun]
    @subkegiatan_sasarans = @user.subkegiatan_sasarans_tahun(@tahun)
  end

  def anggaran_belanja
    @tahun = cookies[:tahun]
    @sasaran = Sasaran.find(params[:id])
  end

  def list_sasaran
    param = params[:q] || ""
    @opd = current_user.opd
    # TODO: simplify method
    @sasarans = @opd.sasarans
                    .dengan_rincian
                    .merge(@opd.users.asn_aktif)
                    .where("sasaran_kinerja ILIKE ?", "%#{param}%").limit(50)
  end

  def data_detail
    @sasaran = Sasaran.find(params[:id])
    respond_to do |format|
      format.html { render partial: 'templates/data_pembuka_wawasan_card', locals: { sasaran: @sasaran } }
      format.json
    end
  end

  def rencana_aksi
    @sasaran = Sasaran.find(params[:id])
    render partial: 'templates/rencana_aksi_card', locals: { sasaran: @sasaran }
  end

  # GET /sasarans/1 or /sasarans/1.json
  def show
    @tahun = cookies[:tahun] || Date.current.year
  end

  # TODO: refactor and simplify
  def laporan_kak(tahun: '')
    @program_kegiatans = ProgramKegiatan.joins(:sasarans).where(sasarans: { nip_asn: current_user.nik,
                                                                            tahun: tahun }).group(:id)
    @jumlah_sasaran = ProgramKegiatan.joins(:sasarans).where(sasarans: { nip_asn: current_user.nik,
                                                                         tahun: tahun }).count(:sasarans)
    @jumlah_subkegiatan = ProgramKegiatan.includes(:sasarans).where(sasarans: { nip_asn: current_user.nik,
                                                                                tahun: tahun }).count
    @jumlah_usulan = ProgramKegiatan.includes(:sasarans).where(sasarans: { nip_asn: current_user.nik,
                                                                           tahun: tahun }).map do |program|
      program.sasarans.where(tahun: tahun).map do |s|
        s.usulans.count
      end.reduce(:+)
    end.reduce(:+)
    @total_pagu = @program_kegiatans.map do |program|
      program.sasarans.where(tahun: tahun).sudah_lengkap.map(&:total_anggaran).compact.sum
    end.sum
    @sasarans = Sasaran.sudah_lengkap.where(nip_asn: current_user.nik).where(tahun: tahun)
  end

  def detail
    @program_kegiatan = @sasaran.program_kegiatan
  end

  def sasaran_admin
    action = params[:button]
    keyword = params[:keyword]
    @sasarans = if keyword && action == 'cari'
                  Sasaran.where("nip_asn ILIKE ?", "%#{keyword}%")
                         .or(Sasaran.where("nip_asn_sebelumnya ILIKE ?", "%#{keyword}%"))
                         .dengan_strategi
                else
                  []
                end
  end

  def edit_nip
    @sasaran = Sasaran.find(params[:id])
    @nip = @sasaran.nip_asn
    render partial: "form_nip"
  end

  def update_nip
    @sasaran = Sasaran.find(params[:id])

    return unless @sasaran

    @strategi = @sasaran.strategi

    @nip_lama = params[:nip_lama]
    @nip_baru = params[:nip_baru]

    @sasaran.nip_asn_sebelumnya = @nip_lama
    @strategi.nip_asn_sebelumnya = @nip_lama
    @sasaran.nip_asn = @nip_baru
    @strategi.nip_asn = @nip_baru

    return unless @sasaran.save && @strategi.save

    respond_to do |f|
      f.js
    end
  end

  def daftar_subkegiatan
    @sasarans = Sasaran.includes(:program_kegiatan).where.not(program_kegiatan: { id: nil })
  end

  def pdf_daftar_subkegiatan; end

  def hapus_program_from_sasaran
    param_id = params[:id_sasaran]
    sasaran = Sasaran.find(param_id)
    respond_to do |format|
      if sasaran.update(program_kegiatan_id: nil)
        @status = 'success'
        @text = 'Sukses menghapus program kegiatan'
        format.js
      else
        @status = 'error'
        @text = 'Terjadi kesalahan saat menghapus program kegiatan'
        format.js :unprocessable_entity
      end
    end
  end

  def hapus_tematik_from_sasaran
    id_sasaran = params[:id_sasaran]
    id_tematik = params[:id_tematik]
    TematikSasaran.where(sasaran_id: id_sasaran, subkegiatan_tematik_id: id_tematik).first.destroy
    respond_to do |format|
      @status = 'success'
      @text = 'Sukses menghapus tematik'
      format.js { render :hapus_program_from_sasaran }
    end
  end

  def add_sasaran_tematik
    sasaran = Sasaran.find(params[:id_sasaran])
    tematik = params[:id_tematik]
    respond_to do |format|
      if sasaran.add_tematik(sasaran: sasaran.id, tematik: tematik)
        @status = 'success'
        @text = 'Sukses menambah tematik'
        format.js { render :hapus_program_from_sasaran }
      else
        @status = 'error'
        @text = 'Terjadi kesalahan saat menambah tematik'
        format.js { render :hapus_program_from_sasaran, :unprocessable_entity }
      end
    end
  end

  def renaksi_update
    @sasaran.sync_total_renaksi
    flash.now[:success] = 'Perhitungan Renaksi Berhasil'
  end

  def laporan_sasaran
    @sasarans = User.asn_aktif.where(kode_opd: current_user.kode_opd)
  end

  def verifikasi_sasaran
    @sasarans = Sasaran.where.not(status: 'draft').select do |s|
      s.user.opd.id_opd_skp == current_user.opd.id_opd_skp or current_user.has_role? :super_admin
    end
  end

  def ajukan_semua_sasaran
    sasarans = params[:sasaran_diajukans]
    Sasaran.where(id: sasarans).update_all(status: 'pengajuan')
    respond_to do |format|
      flash[:success] = 'KaK Diajukan'
      @status = 'success'
      @text = 'KaK Berhasil Diajukan'
      format.js { render 'update.js.erb' }
    end
  end

  def ajukan_verifikasi
    @sasaran = Sasaran.find(params[:id])
    @sasaran.update(status: 'pengajuan')
    render 'shared/_notifier_v2',
           locals: { message: 'Sasaran berhasil diajukan', status_icon: 'success', form_name: 'non-exists' }
  end

  def setujui_semua_sasaran
    @sasarans = params[:sasaran_diajukans]
    respond_to do |format|
      @rowspan = params[:rowspan]
      @dom = params[:dom]
      flash.now[:success] = 'KaK disetujui'
      Sasaran.where(id: @sasarans.flatten!).update_all(status: 'disetujui')
      @status = 'success'
      @type = 'setuju'
      @text = 'KaK Berhasil Disetujui'
      format.js { render 'update_kak.js.erb' }
    end
  end

  def revisi_semua_sasaran
    @sasarans = params[:sasaran_diajukans]
    Sasaran.where(id: @sasarans.flatten!).update_all(status: 'draft')
    respond_to do |format|
      @rowspan = params[:rowspan]
      @dom = params[:dom]
      flash.now[:info] = 'Kuncian Dibuka'
      @status = 'warning'
      @type = 'revisi'
      @text = 'Kuncian Dibuka'
      format.js { render 'update_kak.js.erb' }
    end
  end

  def tolak_semua_sasaran
    @sasarans = params[:sasaran_diajukans]
    Sasaran.where(id: @sasarans.flatten!).update_all(status: 'ditolak')
    respond_to do |format|
      @rowspan = params[:rowspan]
      @dom = params[:dom]
      flash.now[:warning] = 'KaK ditolak'
      @status = 'warning'
      @type = 'ditolak'
      @text = 'KaK ditolak'
      format.js { render 'update_kak.js.erb' }
    end
  end

  def setujui
    # @sasaran = Sasaran.find(params[:id])
    # @sasaran.update(status: 'disetujui')
    # render 'shared/_notifier_v2', locals: { message: 'Sasaran disetujui', status_icon: 'success', form_name: 'non-exists' }
    @sasaran = params[:id]
    Sasaran.find(@sasaran).update(status: 'disetujui')
    respond_to do |format|
      @rowspan = params[:rowspan]
      @dom = params[:dom]
      flash.now[:success] = ['Rencana Kinerja dikunci', 'dikunci']
      @status = 'dikunci'
      @type = 'setuju'
      @text = 'Rencana Kinerja dikunci'
      format.js { render 'update_kak.js.erb' }
    end
  end

  def tolak
    @sasaran = Sasaran.find(params[:id])
    @sasaran.update(status: 'ditolak')
    render 'shared/_notifier_v2', locals: { message: 'Sasaran ditolak', status_icon: 'info', form_name: 'non-exists' }
  end

  def revisi
    # @sasaran = Sasaran.find(params[:id])
    # @sasaran.update(status: 'draft')
    # render 'shared/_notifier_v2', locals: { message: 'Revisi', status_icon: 'warning', form_name: 'non-exists' }
    @sasaran = params[:id]
    Sasaran.find(@sasaran).update(status: 'draft')
    respond_to do |format|
      @rowspan = params[:rowspan]
      @dom = params[:dom]
      flash.now[:info] = ['Rencana Kinerja dibuka', 'dibuka']
      @status = 'dibuka'
      @type = 'revisi'
      @text = 'Rencana Kinerja dibuka'
      format.js { render 'update_kak.js.erb' }
    end
  end

  # GET /sasarans/new
  def new
    @sasaran = @user.sasarans.build
    @tipe = params[:tipe]
    @sasaran.indikator_sasarans.build
    @tahun = cookies[:tahun]
  end

  def new_spbe
    @sasaran = Sasaran.new
    @sasaran.indikator_sasarans.build
    @tipe = 'spbe'
    @kode_opd = params[:kode_opd]
    render partial: 'form_sasaran_spbe', locals: { sasaran: @sasaran }
  end

  def edit_sasaran_spip
    @sasaran = Sasaran.find(params[:id])
    @kode_opd = params[:kode_opd]
    render partial: 'form_sasaran_spbe', locals: { sasaran: @sasaran }
  end

  def edit_admin
    @sasaran = Sasaran.find(params[:id])
    @user = @sasaran.user
    @tahun = cookies[:tahun] || Date.current.year
  end

  def subkegiatan_spbe
    @sasaran = Sasaran.find(params[:id])
    render partial: 'form_subkegiatan_spbe', locals: { sasaran: @sasaran }
  end

  # GET /sasarans/1/edit
  def edit
    @tahun = cookies[:tahun]
    @tipe = params[:tipe]
  end

  # POST /sasarans or /sasarans.json
  def create
    @user = current_user
    @sasaran = if (@user.roles & %i[admin super_admin]).present?
                 Sasaran.new(sasaran_params)
               else
                 @user.sasarans.build(sasaran_params)
               end
    respond_to do |format|
      if @sasaran.save
        format.json { render json: { resText: "Sasaran tersimpan", id: @sasaran.id }.to_json, status: :created }
        format.html { redirect_to sasaran_path(@sasaran), success: 'Sasaran berhasil dibuat.' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sasaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sasarans/1 or /sasarans/1.json
  def update
    # @sasaran = @user.sasarans.find(params[:id])
    respond_to do |format|
      if @sasaran.update(sasaran_params)
        flash[:success] = if sasaran_params[:program_kegiatan_id]
                            'Sukses menambah subkegiatan'
                          elsif sasaran_params[:sumber_dana]
                            'Sumber dana disimpan'
                          else
                            'Sukses update sasaran'
                          end
        @status = 'success'
        @text = 'Sukses menambah tematik'
        format.js { render 'update.js.erb' }
        format.html { redirect_to sasarans_path, success: 'Sasaran diupdate.' }
        format.json { render :show, status: :ok, location: @sasaran }
      else
        flash.now[:error] = 'Sasaran gagal update.'
        format.js
        # format.html { redirect_to user_sasaran_path(@user, @sasaran), error: 'Sasaran gagal update.' }
        format.html { redirect_to sasarans_path, success: 'Sasaran gagal diupdate' }
        format.json { render json: @sasaran.errors, status: :unprocessable_entity }
      end
    end
  end

  def pilih_asn
    @sasaran = Sasaran.find(params[:id])
    respond_to do |format|
      if @sasaran.update(sasaran_params)
        flash[:success] = if sasaran_params[:program_kegiatan_id]
                            'Sukses menambah subkegiatan'
                          elsif sasaran_params[:sumber_dana]
                            'Sumber dana disimpan'
                          else
                            'Sukses update sasaran'
                          end
        @status = 'success'
        @text = 'Sukses menambah tematik'
        format.js { render 'update.js.erb' }
        # format.html { redirect_to user_sasaran_path(@user, @sasaran) }
        format.html { redirect_to sasarans_path, success: 'Sasaran diupdate.' }
        format.json { render :show, status: :ok, location: @sasaran }
      else
        flash.now[:error] = 'Sasaran gagal update.'
        format.js
        # format.html { redirect_to user_sasaran_path(@user, @sasaran), error: 'Sasaran gagal update.' }
        format.html { redirect_to sasarans_path, success: 'Sasaran gagal diupdate' }
        format.json { render json: @sasaran.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sasarans/1 or /sasarans/1.json
  def destroy
    nip_sebelum = current_user.nik
    id_rencana_sebelum = @sasaran.id_rencana
    @sasaran.dasar_hukums.destroy_all
    @sasaran.update(nip_asn_sebelumnya: nip_sebelum, nip_asn: nil, strategi_id: nil,
                    deleted_at: DateTime.current, program_kegiatan_id: nil,
                    keterangan_hapus: 'dihapus user', deleted_by: current_user.id,
                    id_rencana_sebelum: id_rencana_sebelum, id_rencana: nil)
    respond_to do |format|
      format.html { redirect_to sasarans_path, success: 'Sasaran berhasil dihapus' }
      format.json { head :no_content }
    end
  end

  def subkegiatan
    sasaran = Sasaran.find(params[:id])
    @nama_sasaran = sasaran.sasaran_kinerja
    @subkegiatan = sasaran.subkegiatan
    @anggaran_sasaran = sasaran.total_anggaran || 0
    render partial: "subkegiatan_sasaran"
  end

  def clone_tahapan_sebelum
    sasaran = Sasaran.find(params[:id])
    begin
      sasaran.renaksi_cloner
      redirect_to sasaran_path(sasaran), success: 'Renaksi diclone'
    rescue ActiveRecord::RecordNotUnique
      flash.now[:error] = 'Renaksi Sudah dikloning'
      redirect_to sasaran_path(sasaran), success: 'Gagal Clone'
    rescue ActiveRecord::RecordInvalid
      flash.now[:error] = 'Renaksi Tidak ditemukan'
      redirect_to sasaran_path(sasaran), success: 'Gagal Clone'
    rescue StandardError
      flash.now[:error] = 'Terjadi Kesalahan'
      redirect_to sasaran_path(sasaran), success: 'Gagal Clone'
    end
  end

  def list_all
    keyword = params[:keyword]
    @users = if keyword
               Sasaran.where("nik ILIKE ?", "%#{keyword}%")
             else
               []
             end
  end

  def rincian; end

  def review; end

  def hasil_output
    @sasaran = Sasaran.find(params[:id])
    hasil_output = sasaran_params[:hasil_output]
    nama_output = sasaran_params[:nama_output]
    prev_metadata = @sasaran.metadata.present? ? @sasaran.metadata : {}
    new_metadata = prev_metadata.merge({ hasil_output: hasil_output, nama_output: nama_output,
                                         processed_at: DateTime.current })
    if @sasaran.update(metadata: new_metadata)
      render json: { resText: "Output sasaran diupdate",
                     html_content: html_content({ sasaran: @sasaran },
                                                partial: 'sasarans/hasil_output') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan", html_content: errors_content(@sasaran) }.to_json,
             status: :unprocessable_entity
    end
  end

  def inovasi
    @sasaran = Sasaran.find(params[:id])
    hasil_inovasi = sasaran_params[:hasil_inovasi]
    inovasi_sasaran = sasaran_params[:inovasi_sasaran]
    prev_metadata = @sasaran.metadata.present? ? @sasaran.metadata : {}
    new_metadata = prev_metadata.merge({ hasil_inovasi: hasil_inovasi, inovasi_sasaran: inovasi_sasaran,
                                         processed_at: DateTime.current })
    if @sasaran.update(metadata: new_metadata)
      render json: { resText: "Inovasi sasaran disimpan",
                     html_content: html_content({ sasaran: @sasaran },
                                                partial: 'sasarans/hasil_inovasi') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan", html_content: errors_content(@sasaran) }.to_json,
             status: :unprocessable_entity
    end
  end

  def edit_output
    @sasaran = Sasaran.find(params[:id])
    render partial: 'form_edit_output'
  end

  def edit_inovasi
    @sasaran = Sasaran.find(params[:id])
    render partial: 'form_edit_inovasi'
  end

  private

  def errors_content(sasaran)
    render_to_string(partial: 'error',
                     formats: 'html',
                     layout: false,
                     locals: { sasaran: sasaran })
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  def set_program_kegiatan
    @program_kegiatan = ProgramKegiatan.find(params[:program_kegiatan_id])
  end

  def set_sasaran
    @sasaran = Sasaran.find(params[:id])
  end

  def set_dropdown
    @users = User.all
  end

  def filter_sasaran(query)
    case query
    when 'dengan_strategi'
      @sasarans.dengan_strategi
    when 'belum_lengkap'
      @sasarans.kurang_lengkap
    when 'sudah_lengkap'
      @sasarans.sudah_lengkap
    else
      @sasarans
    end
  end

  # Only allow a list of trusted parameters through.
  def sasaran_params
    params.require(:sasaran).permit(:sasaran_kinerja, :penerima_manfaat, :nip_asn, :program_kegiatan_id,
                                    :sumber_dana, :subkegiatan_tematik_id, :tahun, :id_rencana,
                                    :anggaran, :type,
                                    :hasil_output,
                                    :nama_output,
                                    :hasil_inovasi,
                                    :inovasi_sasaran,
                                    :strategi_id,
                                    :kelompok_anggaran, :filter_file, :filter_target, :filter_type, :sasaran_milik,
                                    indikator_sasarans_attributes: %i[id indikator_kinerja aspek target satuan _destroy])
  end

  rescue_from ActionController::ParameterMissing do
    render 'shared/_notifier', locals: { message: 'isian belum terisi' }, status: :unprocessable_entity
  end
end
