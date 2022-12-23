class Api::PecelTumpangController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def data_anggarans
    param = params[:q] || ''
    @data_anggarans = Search::AllAnggaran.where('uraian_barang ILIKE ?',
                                                "%#{param}%")
                                         .or(Search::AllAnggaran.where('spesifikasi ILIKE ?', "%#{param}%"))
                                         .limit(80).includes(:searchable).collect(&:searchable)
  end
end
