class SpipController < ApplicationController
  before_action :opd_params, :tahun_params
  def index
    return if @kode_opd.nil?

    spip = SpipQueries.new(TujuanKota, tahun: @tahun, opd: @opd)
    @informasi_umum = spip.informasi_umum_sasaran_kota
    @daftar_opd = spip.daftar_opd
    @sasaran_opd = spip.sasaran_opd
    @sasaran_opd_spip = spip.spip_sasaran_opd
  end

  def cetak_excel
    spip = SpipQueries.new(TujuanKota, tahun: @tahun, opd: @opd)
    @informasi_umum = spip.informasi_umum_sasaran_kota
    @daftar_opd = spip.daftar_opd
    @sasaran_opd = spip.sasaran_opd
    @sasaran_opd_spip = spip.spip_sasaran_opd
    @filename = "Template_import_Kota_Madiun #{@opd.nama_opd}.xlsx"
    render xlsx: "excel_spip_new", filename: @filename, disposition: "attachment"
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
