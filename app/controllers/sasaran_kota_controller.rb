class SasaranKotaController < ApplicationController
  def index
    @sasaran_kota = SasaranKota.includes(:indikator_sasarans).all
  end
end
