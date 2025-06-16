module RekapitulasiRencanaAksiOpd
  class LaporansController < ApplicationController
    before_action :set_default_attr
    def data; end

    def jumlah; end

    def set_default_attr
      @user = current_user
      @kode_opd = cookies[:opd]
      @tahun = cookies[:tahun]
    end
  end
end
