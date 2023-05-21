class LaporansController < ApplicationController
  before_action :set_default, only: %i[laporan_rka laporan_kak laporan_kak_admin laporan_rka_admin]

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
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd

    @program_kegiatans = opd.strategis
                            .where("role = ? and tahun ILIKE ?", "eselon_4", "%#{@tahun}%")
                            .map(&:sasaran)
                            .group_by(&:program_kegiatan)

    render partial: "laporans/kak_admin"
  end

  def laporan_rka
    @nip_asn = current_user.nik
    @program_kegiatans = @user.subkegiatan_sasarans_tahun(@tahun)
  end

  def laporan_rka_admin
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd

    @program_kegiatans = opd.strategis
                            .where("role = ? and tahun ILIKE ?", "eselon_4", "%#{@tahun}%")
                            .map(&:sasaran)
                            .group_by(&:program_kegiatan)

    render partial: "laporans/rka_admin"
  end

  private

  def set_default
    @user = current_user
    @kode_opd = cookies[:opd]
    @tahun = cookies[:tahun] || Date.current.year
  end
end
