class SasaranKotaController < ApplicationController
  def index
    @sasaran_kota = SasaranKotum.all
  end

  def crosscutting_kota; end
end
