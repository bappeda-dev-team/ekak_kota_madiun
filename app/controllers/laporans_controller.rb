class LaporansController < ApplicationController
  before_action :set_default, only: [:laporan_rka]

  def atasan
    # current_user == atasan
    # @users = User.asn_aktif
    @atasans = current_user.users.asn_aktif.includes([:sasarans])
  end

  def laporan_rka
    @nip_asn = current_user.nik
    @program_kegiatans = @user.subkegiatan_sasarans_tahun(@tahun)
  end

  private

  def set_default
    @user = current_user
    @tahun = cookies[:tahun] || nil
  end
end
