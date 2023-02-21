class PohonKinerjaController < ApplicationController
  def kota; end

  def opd
    @opd = Opd.find(136)
    nip_kepala = @opd.users.eselon2.first.nik
    @pohons = @opd.pohons
    @strategis = Strategi.where(nip_asn: nip_kepala)
  end

  def asn
    @opd = Opd.find(136)
    @pohons = @opd.pohons
    @user = User.find_by(nik: current_user.nik)
    @eselon = @user.eselon_user
    @strategis = Strategi.where(nip_asn: @user.nik)
  end
end
