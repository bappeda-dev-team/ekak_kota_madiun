class SpipController < ApplicationController
  before_action :opd_params, :tahun_params
  def index
    @tujuan_kota = TujuanKota.joins(%i[indikator_tujuans sasaran_kota]).where.not(visi: nil).group_by(&:visi)
                             .map { |visi, tujuans| [visi, tujuans.group_by(&:misi)] }.to_h
  end

  def cetak_excel
    @filename = "Template_import_Kota_Madiun #{@opd.nama_opd}.xlsx"
    render xlsx: "excels/excel_spip_new", filename: @filename, disposition: "attachment"
  end

  private

  def opd_params
    @kode_opd = params[:kode_opd] || cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
  end

  def tahun_params
    @tahun = cookies[:tahun]
  end
end
