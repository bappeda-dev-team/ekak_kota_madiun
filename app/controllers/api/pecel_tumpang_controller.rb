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

  def kinerja_opd
    @tahun = params[:tahun]
    kode_opd = params[:kode_opd]
    jenis_data = params[:jenis_data]

    opd = Opd.find_by(kode_unik_opd: kode_opd)
    @nama_opd = opd.nama_opd

    opd.users.aktif.map do |user|
      user.sasarans_tahun(@tahun)
    end => list_kinerja_opd

    @list_kinerja_opd = list_kinerja_opd.flatten.filter do |sas|
      sas.indikator_sasarans.filter_map { |ind| ind.output_data.include?(jenis_data) }.present?
    end
  end

  private

  def pecel_tumpang_params
    params.permit(:tahun, :kode_opd, :jenis_data)
  end
end
