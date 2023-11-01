class HomeController < ApplicationController
  def dashboard
    @tahun = cookies[:tahun]
    @opd = cookies[:opd]
    @nama_opd = cookies[:nama_opd]

    if current_user.has_role?(:asn)
      @sasarans = current_user.sasarans_tahun(@tahun)
    else
      render partial: 'home/nonaktif'
    end
  end
end
