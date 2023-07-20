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
    @program_kegiatans = kak.program_kegiatans
  end

  def laporan_kak_admin
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd

    kak = KakQueries.new(opd: opd, tahun: @tahun)
    @program_kegiatans = kak.program_kegiatans

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
    @sasarans = @program_kegiatan.sasarans_subkegiatan(@tahun)
  end

  def laporan_rka
    @nip_user = @user.nik
    @nama_user = @user.nama
    kak = KakQueries.new(opd: @user.opd, tahun: @tahun, user: @user)
    @program_kegiatans = kak.program_kegiatans
  end

  def laporan_rka_admin
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd

    kak = KakQueries.new(opd: opd, tahun: @tahun)
    @program_kegiatans = kak.program_kegiatans

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

  private

  def set_program_kegiatans
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @program_kegiatans = @opd.program_renstra
  end

  def set_default_attr
    @user = current_user
    @kode_opd = cookies[:opd]
    @tahun = cookies[:tahun] || Date.current.year
  end
end
