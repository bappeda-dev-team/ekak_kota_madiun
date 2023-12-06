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

  def data_kependudukan
    @tahun = params[:tahun]
    kode_opd = params[:kode_opd]

    opd = Opd.find_by(kode_unik_opd: kode_opd)
    @nama_opd = opd.nama_opd
  end
end
