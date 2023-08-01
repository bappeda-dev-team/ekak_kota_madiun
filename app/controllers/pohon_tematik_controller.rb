class PohonTematikController < ApplicationController
  include ActionView::RecordIdentifier

  layout false, only: %i[new edit]

  def new
    tahun = cookies[:tahun]
    @tematiks = Tematik.all
    @pohon = Pohon.new(pohonable_type: 'PohonTematik', role: 'pohon_kota', tahun: tahun)
  end

  def create; end
end
