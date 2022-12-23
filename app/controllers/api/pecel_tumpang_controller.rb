class Api::PecelTumpangController < ApplicationController
  def data_anggarans
    param = params[:q] || ''
    @data_anggarans = Search::AllAnggaran.where('uraian_barang ILIKE ?',
                                                "%#{param}%")
                                         .or(Search::AllAnggaran.where('spesifikasi ILIKE ?', "%#{param}%"))
                                         .limit(80).includes(:searchable).collect(&:searchable)
  end
end
