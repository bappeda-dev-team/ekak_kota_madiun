class HomeController < ApplicationController
  def dashboard
    @tahun = cookies[:tahun]
    if current_user.has_role?(:asn)
      @sasarans = current_user.sasarans_tahun(@tahun)
    else
      render partial: 'home/nonaktif'
    end
  end
end
