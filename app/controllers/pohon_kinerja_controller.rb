class PohonKinerjaController < ApplicationController
  def kota; end

  def opd
    @opd = current_user.opd
    nip_kepala = @opd.users.eselon2.first&.nik
    @pohons = @opd.pohons
    @strategis = Strategi.where(nip_asn: nip_kepala)
  end

  def asn
    @opd = current_user.opd
    @pohons = @opd.pohons
    @user = User.find_by(nik: current_user.nik)
    @eselon = @user.eselon_user
    @strategis = Strategi.where(nip_asn: @user.nik)
  end
end
