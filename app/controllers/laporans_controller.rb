class LaporansController < ApplicationController
  before_action :set_default, only: %i[laporan_rka laporan_kak laporan_kak_admin]

  def atasan
    # current_user == atasan
    # @users = User.asn_aktif
    @atasans = current_user.users.asn_aktif.includes([:sasarans])
  end

  def laporan_kak
    @nip_asn = @user.nik
    @program_kegiatans = @user.subkegiatan_sasarans_tahun(@tahun)
  end

  def laporan_kak_admin
    # kak = KakService.new(kode_unik_opd: @kode_opd, tahun: @tahun)
    # @program_kegiatans = kak.sasarans_by_user
    # @total_pagu = kak.total_pagu
    # @jumlah_subkegiatan = kak.laporan_rencana_kinerja.size
    # @total_sasaran_aktif = kak.total_sasaran_aktif
    # @total_usulans = kak.total_usulan_musrenbang
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd
    @operational_obj = opd.operational_tahun(@tahun)
    render partial: "laporans/kak_admin"
  end

  def laporan_rka
    @nip_asn = current_user.nik
    @program_kegiatans = @user.subkegiatan_sasarans_tahun(@tahun)
  end

  private

  def set_default
    @user = current_user
    @kode_opd = cookies[:opd]
    @tahun = cookies[:tahun] || Date.current.year
  end
end
