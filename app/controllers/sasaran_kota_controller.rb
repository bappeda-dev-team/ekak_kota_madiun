class SasaranKotaController < ApplicationController
  def index
    @sasaran_kota = SasaranKota.all
  end
end
