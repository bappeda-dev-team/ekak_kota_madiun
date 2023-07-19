class HomeController < ApplicationController
  def dashboard
    @tahun = cookies[:tahun]
    if current_user.has_role?(:super_admin)
      @kelompok_anggarans = KelompokAnggaran.all.order(:tahun, :kelompok)
      @opds = Opd.opd_resmi.order(:nama_opd)
    elsif current_user.has_role?(:admin)
      @kelompok_anggarans = KelompokAnggaran.all.order(:tahun, :kelompok)
      kode_opd = current_user.kode_opd
      @opds = Opd.where(kode_opd: kode_opd)
    elsif current_user.has_role?(:asn)
      @sasarans = current_user.sasarans_tahun(@tahun)
    else
      render partial: 'home/nonaktif'
    end
  end
end
