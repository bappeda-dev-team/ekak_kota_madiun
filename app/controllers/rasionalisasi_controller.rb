class RasionalisasiController < ApplicationController

  def rasionalisasi
    # hello world
  end

  def rasional_sasaran
    sasaran = params[:sasaran]
    @sasaran = Sasaran.find(sasaran)
  end
end
