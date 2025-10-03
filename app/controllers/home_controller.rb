class HomeController < ApplicationController
  def dashboard
    @tahun = cookies[:tahun]
    @opd = cookies[:opd]
    @nama_opd = cookies[:nama_opd]

    return unless current_user.has_role?(:asn)

    @opd_id = Opd.find_by(kode_unik_opd: @opd).id.to_s
    @sasarans = current_user.sasaran_untuk_dashboard(@tahun, @opd_id)
  end
end
