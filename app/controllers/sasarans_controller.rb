class SasaransController < ApplicationController
  before_action :set_user, only: %i[index new anggaran]
  before_action :set_sasaran,
                only: %i[show edit update destroy update_program_kegiatan renaksi_update detail review rincian
                         input_rtp simpan_rtp update_dampak verifikasi_risiko update_subkegiatan]
  before_action :set_dropdown, only: %i[new edit]

  layout false, only: [:input_rtp]

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
    @sasarans = @user.legacy_sasaran_user(@tahun)
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

  def show_kak_user
    @tahun = cookies[:tahun]
    @sasaran = Sasaran.find(params[:id])
    @program_kegiatan = @sasaran.program_kegiatan
    indikators_pks = IndikatorQueries.new(tahun: @tahun, opd: @program_kegiatan.opd,
                                          program_kegiatan: @program_kegiatan)
    @indikator_program = indikators_pks.indikator_program
    @indikator_kegiatan = indikators_pks.indikator_kegiatan
    @indikator_subkegiatan = indikators_pks.indikator_subkegiatan
  end

  def show_pokin_user
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @sasaran = Sasaran.find(params[:id])
    @pohon = @sasaran.strategi.strategi_atasan.strategi_atasan
    @title = @pohon.to_s || '-'
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
    nip_asn = params[:nip_asn]
    @sasarans = if nip_asn && action == 'cari'
                  Sasaran.cari_nip_asn(nip_asn)
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

    @nip_lama = params[:nip_lama]
    @nip_baru = params[:nip_baru]

    @sasaran.nip_asn_sebelumnya = @nip_lama
    @sasaran.nip_asn = @nip_baru

    return unless @sasaran.save

    @strategi = @sasaran.strategi

    if @strategi.present?
      @strategi.nip_asn = @nip_baru
      @strategi.nip_asn_sebelumnya = @nip_lama
    end

    respond_to do |f|
      f.js
    end
  end

  def daftar_subkegiatan
    @sasarans = Sasaran.includes(:program_kegiatan).where.not(program_kegiatan: { id: nil })
  end

  def pdf_daftar_subkegiatan; end

  def hapus_program_from_sasaran
    @tahun = cookies[:tahun] || Date.current.year
    @sasaran = Sasaran.find(params[:id])
    @sasaran.update(program_kegiatan_id: nil)

    render json: { resText: "Subkegiatan berhasil dihapus",
                   html_content: html_content({ sasaran: @sasaran,
                                                tahun: @tahun },
                                              partial: 'sasarans/subkegiatan_card') }.to_json,
           status: :ok
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

  def update_subkegiatan
    @tahun = cookies[:tahun] || Date.current.year
    if @sasaran.update(sasaran_params)

      render json: { resText: "Subkegiatan ditambahkan",
                     html_content: html_content({ sasaran: @sasaran,
                                                  tahun: @tahun },
                                                partial: 'sasarans/subkegiatan_card') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ sasaran: @sasaran,
                                                   tahun: @tahun },
                                                 partial: 'sasarans/subkegiatan_card') }.to_json,
             status: :unprocessable_entity
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
    # nip_sebelum = current_user.nik
    # id_rencana_sebelum = @sasaran.id_rencana
    @sasaran.indikator_sasarans.destroy_all
    @sasaran.dasar_hukums.destroy_all
    @sasaran.tahapans.destroy_all
    # @sasaran.update(nip_asn_sebelumnya: nip_sebelum, nip_asn: nil, strategi_id: nil,
    #                 deleted_at: DateTime.current, program_kegiatan_id: nil,
    #                 keterangan_hapus: 'dihapus user', deleted_by: current_user.id,
    #                 id_rencana_sebelum: id_rencana_sebelum, id_rencana: nil)
    @sasaran.destroy
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
      # redirect_to sasaran_path(sasaran), success: 'Renaksi diclone'
      render json: { resText: "Renaksi diclone" },
             status: :ok
    rescue ActiveRecord::RecordNotUnique
      flash.now[:error] = 'Renaksi Sudah dikloning'
      redirect_to sasaran_path(sasaran), success: 'Gagal Clone'
    rescue ActiveRecord::RecordInvalid
      flash.now[:error] = 'Renaksi Tidak ditemukan'
      redirect_to sasaran_path(sasaran), success: 'Gagal Clone'
    rescue StandardError
      render json: { resText: "Terjadi kesalahan",
                     html_content: "<p class='alert alert-danger'>Error, coba clone lagi dalam beberapa saat</p>" },
             status: :service_unavailable
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
                                                partial: 'sasarans/hasil_output_card') }.to_json,
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
    jenis_inovasi = sasaran_params[:jenis_inovasi]
    gambaran_nilai_kebaruan = sasaran_params[:gambaran_nilai_kebaruan]
    prev_metadata = @sasaran.metadata.present? ? @sasaran.metadata : {}
    new_metadata = prev_metadata.merge({ hasil_inovasi: hasil_inovasi,
                                         jenis_inovasi: jenis_inovasi,
                                         inovasi_sasaran: inovasi_sasaran,
                                         gambaran_nilai_kebaruan: gambaran_nilai_kebaruan,
                                         processed_at: DateTime.current })
    if @sasaran.update(metadata: new_metadata)
      render json: { resText: "Inovasi sasaran disimpan",
                     html_content: html_content({ sasaran: @sasaran },
                                                partial: 'sasarans/hasil_output_inovasi_card') }.to_json,
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

  def laporan_inovasi
    @sasaran = Sasaran.find(params[:id])
    @kode_opd = @sasaran.opd.kode_unik_opd
    @tahun = @sasaran.tahun
    @strategi = @sasaran.strategi
    @strategi_atasan = @strategi.strategi_atasan
    @inovasi = @sasaran.inovasi_sasaran
    @kebaruan = @sasaran.gambaran_nilai_kebaruan
    tim_kerja = TimKerja.new(kode_opd: @kode_opd,
                             tahun: @sasaran.tahun)
    @tim = tim_kerja.tim_kerja_hash(@strategi_atasan)
  end

  def input_rtp
    @butuh_verifikasi = params[:butuh_verifikasi]
    @laporan = params[:laporan]
    @nomor = params[:nomor_sasaran]
    @tahapans = @sasaran.tahapans
  end

  def simpan_rtp
    @butuh_verifikasi = params[:butuh_verifikasi]
    laporan = params[:laporan]
    nomor = params[:nomor_sasaran]
    tahapan_id = params[:is_rtp]
    @sasaran.butuh_verifikasi = @butuh_verifikasi
    @sasaran.tahapans.each do |tahapan|
      if tahapan.rtp_mr? && tahapan.id.to_s != tahapan_id
        tahapan.tagging = ""
        tahapan.tahun_tagging = ""
        tahapan.save
      elsif tahapan.id.to_s == tahapan_id
        tahapan.tagging = "RTP-MR"
        tahapan.tahun_tagging = @sasaran.tahun
        tahapan.save
      end
    end
    render json: { html_content: html_content({ show_sasaran: @sasaran, nomor: nomor, laporan: laporan },
                                              partial: 'daftar_risiko/row_daftar_risiko') }
      .to_json, status: :ok
  end

  def update_dampak
    laporan = params[:laporan]
    nomor = params[:nomor_sasaran]
    if @sasaran.update(manrisk_sasaran_params)
      render json: { html_content: html_content({ show_sasaran: @sasaran, nomor: nomor, laporan: laporan },
                                                partial: 'daftar_risiko/row_daftar_risiko') }
        .to_json, status: :ok
    else
      render json: { html_content: html_content({ sasaran: @sasaran, nomor: nomor },
                                                partial: 'sasaran_program_opds/form_dampak') }
        .to_json, status: :unprocessable_entity
    end
  end

  def verifikasi_risiko
    @butuh_verifikasi = params[:butuh_verifikasi]
    @laporan = params[:laporan]
    @nomor = params[:nomor_sasaran]
    @sasaran.butuh_verifikasi = @butuh_verifikasi
    if @sasaran.update(manrisk_sasaran_params)
      render json: { html_content: html_content({ show_sasaran: @sasaran, nomor: @nomor, laporan: @laporan },
                                                partial: 'daftar_risiko/row_daftar_risiko') }
        .to_json, status: :ok
    else
      render json: { html_content: html_content({ sasaran: @sasaran },
                                                partial: 'sasaran_program_opds/verifikasi_dampak_resiko') }
        .to_json, status: :unprocessable_entity
    end
  end

  def renaksi_opd_list
    q = params[:q]
    @tahun = params[:tahun]
    @kode_opd = params[:kode_opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    # @sasarans = @opd.users_jabatans.eselon4.flat_map do |us|
    #   us.sasarans.includes(%i[strategi indikator_sasarans])
    #     .where(tahun: @tahun)
    #     .where("sasarans.sasaran_kinerja ILIKE ?", "%#{q}%")
    #     .select { |ss| select_sasaran_valid(ss) }
    # end
    @sasarans = @opd.strategis.eselon4_bytahun(@tahun).flat_map do |str|
      str.sasarans.includes(%i[indikator_sasarans])
         .where("sasarans.sasaran_kinerja ILIKE ?", "%#{q}%")
    end.select(&:es4_siaptarik?)

    return unless params[:item]

    @sasarans = Sasaran.where(id_rencana: params[:item])
    # @sasarans = @opd.strategi_eselon4.flat_map do |st|
    #   st.sasaran_pohon_kinerja(tahun: @tahun)
    # end
    # @sasarans = @sasarans.select { |s| s.sasaran_kinerja =~ /#{q}/i }
  end

  def toggle_inovasi_lolos
    @sasaran = Sasaran.find(params[:id])

    if @sasaran.toggle_inovasi_lolos(penilaian_inovasi_sasaran_params)
      render json: { resText: 'Flag diubah',
                     html_content: html_content({ sasaran: @sasaran },
                                                partial: 'sasarans/sasaran_inovasi') }
        .to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan' }.to_json,
             status: :unprocessable_entity
    end
  end

  def penilaian_inovasi
    sasaran = Sasaran.find(params[:id])
    status = params[:status]

    render partial: 'sasarans/form_skor_inovasi', locals: { sasaran: sasaran, status: status }
  end

  def update_nilai_inovasi
    @sasaran = Sasaran.find(params[:id])

    if @sasaran.toggle_inovasi_lolos(penilaian_inovasi_sasaran_params)
      render json: { resText: 'Flag diubah',
                     html_content: html_content({ sasaran: @sasaran },
                                                partial: 'sasarans/sasaran_inovasi') }
        .to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan' }.to_json,
             status: :unprocessable_entity
    end
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
                                    :jenis_inovasi,
                                    :gambaran_nilai_kebaruan,
                                    :status_dampak_resiko,
                                    :komentar_dampak_resiko,
                                    :strategi_id,
                                    :kelompok_anggaran, :filter_file, :filter_target, :filter_type, :sasaran_milik,
                                    indikator_sasarans_attributes: %i[id indikator_kinerja aspek target satuan _destroy])
  end

  def penilaian_inovasi_sasaran_params
    params.require(:sasaran).permit(:inovasi_status, :inovasi_level, :inovasi_catatan)
  end

  def manrisk_sasaran_params
    params.require(:sasaran).permit(:status_dampak_resiko, :komentar_dampak_resiko, :verifikator_dampak_resiko,
                                    rincian_attributes: %i[id resiko kemungkinan_id skala_id dampak])
  end

  rescue_from ActionController::ParameterMissing do
    render 'shared/_notifier', locals: { message: 'isian belum terisi' }, status: :unprocessable_entity
  end
end
