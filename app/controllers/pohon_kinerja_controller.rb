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
    @user = current_user
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

  def excel
    opd_id = params[:pohon_kinerja_id]
    @opd = Opd.find(opd_id)
    @pohons = @opd.pohons
    @kotak_usulan = @opd.usulans
    @isu_strategis_pohon = @opd.isu_strategis_pohon
    @filename = "Pohon Kinerja #{@opd.nama_opd}.xlsx"
    @isu_strategis_kota = IsuStrategisKotum.where(tahun: "2023")
    render xlsx: "excel", filename: @filename, disposition: "inline"
  end
end
