class LaporansController < ApplicationController
  before_action :set_default_attr

  def atasan
    # current_user == atasan
    # @users = User.asn_aktif
    @atasans = current_user.users.asn_aktif.includes([:sasarans])
  end

  def laporan_kak
    @nip_user = @user.nik
    @nama_user = @user.nama
    kak = KakQueries.new(opd: @user.opd, tahun: @tahun, user: @user)
    @program_kegiatans = kak.pk_sasarans
  end

  def laporan_kak_admin
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd

    kak = KakQueries.new(opd: opd, tahun: @tahun)
    @program_kegiatans = kak.pk_sasarans

    render partial: "laporans/kak_admin"
  end

  def buka_kak
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd

    @program_kegiatans = opd.strategis
                            .where(id: params[:id])
                            .map(&:sasaran)
                            .group_by(&:program_kegiatan)
  end

  def pdf_kak
    @program_kegiatan = ProgramKegiatan.find(params[:id])
    @sasarans = @program_kegiatan.sasarans_subkegiatan(@tahun)
    opd = @program_kegiatan.opd
    pdf = LaporanKakPdf.new(opd: opd, tahun: @tahun, program_kegiatan: @program_kegiatan, sasarans: @sasarans)

    waktu = Time.now.strftime("%d_%m_%Y_%H_%M")
    nama_file = @program_kegiatan.nama_subkegiatan
    @filename = "Laporan_KAK_#{nama_file}_#{waktu}.pdf"
    respond_to do |format|
      format.pdf { send_data(pdf.render, filename: @filename, type: 'application/pdf', dispotition: :attachment) }
    end
  end

  def show_kak
    @program_kegiatan = ProgramKegiatan.find(params[:id])
    indikators_pks = IndikatorQueries.new(tahun: @tahun, opd: @program_kegiatan.opd,
                                          program_kegiatan: @program_kegiatan)
    @indikator_program = indikators_pks.indikator_program
    @indikator_kegiatan = indikators_pks.indikator_kegiatan
    @indikator_subkegiatan = indikators_pks.indikator_subkegiatan
    @sasarans = @program_kegiatan.sasarans_subkegiatan(@tahun)
  end

  def laporan_rka
    @nip_user = @user.nik
    @nama_user = @user.nama
    kak = KakQueries.new(opd: @user.opd, tahun: @tahun, user: @user)
    @program_kegiatans = kak.pk_sasarans
  end

  def laporan_rka_admin
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd

    kak = KakQueries.new(opd: opd, tahun: @tahun)
    @program_kegiatans = kak.pk_sasarans

    render partial: "laporans/rka_admin"
  end

  def pdf_rka
    @program_kegiatan = ProgramKegiatan.find(params[:id])
    @sasarans = @program_kegiatan.sasarans_subkegiatan(@tahun)
    opd = @program_kegiatan.opd
    pdf = LaporanRkaPdf.new(opd: opd, tahun: @tahun, program_kegiatan: @program_kegiatan, sasarans: @sasarans)

    waktu = Time.now.strftime("%d_%m_%Y_%H_%M")
    nama_file = @program_kegiatan.nama_subkegiatan
    @filename = "Laporan_RAB_#{nama_file}_#{waktu}.pdf"
    respond_to do |format|
      format.pdf { send_data(pdf.render, filename: @filename, type: 'application/pdf', dispotition: :attachment) }
    end
  end

  def spbe
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @spbe = @opd.program_kegiatans.programs
  end

  def renstra
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @program_kegiatans = @opd.program_renstra
  end

  def ranwal
    set_program_kegiatans
  end

  def rankir1
    set_program_kegiatans
  end

  def rankir2
    set_program_kegiatans
  end

  def penetapan
    set_program_kegiatans
  end

  def hasil_cascading; end

  def cascading_opd
    queries = PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)

    @opd = queries.opd
    @nama_opd = @opd.nama_opd

    # @strategi_kota = queries.strategi_kota
    # @tactical_kota = queries.tactical_kota
    # @operational_kota = queries.operational_kota

    @strategi_opd = queries.strategi_opd
    @tactical_opd = queries.tactical_opd
    @operational_opd = queries.operational_opd
    @staff_opd = queries.staff_opd

    render partial: 'cascading_opd'
  end

  def hasil_cascading_kota
    @tahun = cookies[:tahun]
    @tematiks = Pohon.where(pohonable_type: 'Tematik', tahun: @tahun)
  end

  def cascading_kota
    tematik_id = params[:tematik]
    @pohon = PohonTematikQueries.new(tahun: @tahun)
    @tematik = Tematik.find(tematik_id)
    @tematik_kota = Pohon.where(pohonable_type: 'Tematik',
                                pohonable_id: tematik_id,
                                tahun: @tahun,
                                role: 'pohon_kota')
                         .includes(:pohonable)
    return if @tematik_kota.empty?

    @sub_tematik_kota = @pohon.sub_tematiks
    @sub_sub_tematik_kota = @pohon.sub_sub_tematiks
    @strategi_tematiks = @pohon.strategi_tematiks
    @tactical_tematiks = @pohon.tactical_tematiks
    @operational_tematiks = @pohon.operational_tematiks

    render partial: 'cascading_kota'
  end

  def gender
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @genders = Gender.all
    return unless opd

    @program_kegiatans = opd.program_kegiatans.sasarans
                            .dengan_nip
                            .lengkap_strategi_tahun(@tahun)
  end

  def indikator_rb
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @rb_outcome = @opd.rb_outcome.where(tahun: @tahun)
    @rb_output = @opd.rb_output.where(tahun: @tahun)
  end

  def indikator_lppd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @lppd_outcome = @opd.lppd_outcome.where(tahun: @tahun)
    @lppd_output = @opd.lppd_output.where(tahun: @tahun)
  end

  def indikator_spm; end

  def indikator_sdgs; end

  private

  def set_program_kegiatans
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @program_kegiatans = @opd.program_renstra
  end

  def set_default_attr
    @user = current_user
    @kode_opd = cookies[:opd]
    @tahun = cookies[:tahun]
  end
end
