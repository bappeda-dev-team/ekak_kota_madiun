class HomeController < ApplicationController
  def dashboard
    @tahun = cookies[:tahun]
    if current_user.has_any_role?(:asn, :admin)
      @sasarans = current_user.sasarans_tahun(@tahun)
      @kelompok_anggarans = KelompokAnggaran.all
      @opds = Opd.opd_resmi
    else
      render partial: 'home/nonaktif'
    end
  end
end
