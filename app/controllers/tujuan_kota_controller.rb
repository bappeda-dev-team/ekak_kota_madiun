class TujuanKotaController < ApplicationController
  def index
    @tujuan_kota = TujuanKota.all
  end
end
