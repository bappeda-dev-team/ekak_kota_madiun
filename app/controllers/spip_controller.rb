class SpipController < ApplicationController
  def index
    ##
  end

  def cetak_excel
    @opd = Opd.find_by(kode_unik_opd: params[:kode_unik_opd])
    @filename = "Template_import_Kota_Madiun #{@opd.nama_opd}.xlsx"
    render xlsx: "excels/excel_spip_new", filename: @filename, disposition: "attachment"
  end
end
