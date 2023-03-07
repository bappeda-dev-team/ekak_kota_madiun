class PohonKinerjaController < ApplicationController
  def kota; end

  def opd
    @opd = current_user.opd
    # nip_kepala = @opd.users.eselon2.first&.nik
    @pohons = @opd.pohons
    @strategis = @opd.strategis.where(role: 'eselon_2')
  end

  def asn
    @opd = current_user.opd
    @pohons = @opd.pohons
    @user = User.find_by(nik: current_user.nik)
    @eselon = @user.eselon_user
    @strategis = Strategi.where(nip_asn: @user.nik).select(&:strategi_atasan)
    @strategi_kepala = @opd.strategis.where(nip_asn: @user.nik, role: 'eselon_2')
  end

  def admin_filter
    @kode_opd = params[:kode_opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @pohons = @opd.pohons
    @strategis = @opd.strategis.where(role: 'eselon_2')
    render partial: 'pohon_kinerja/kotak_usulan_asn', locals: { role: 'eselon_2', role_bawahan: 'eselon_3' }
  end

  def print
    @opd = current_user.opd
    # nip_kepala = @opd.users.eselon2.first&.nik
    @pohons = @opd.pohons
    @strategis = @opd.strategis.where(role: 'eselon_2')
  end
end
