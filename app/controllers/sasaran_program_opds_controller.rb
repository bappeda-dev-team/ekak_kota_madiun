class SasaranProgramOpdsController < ApplicationController
  def spip; end

  def excel_spip
    @opd = Opd.find_by(kode_unik_opd: params[:kode_unik_opd])
    @filename = "Template_import_Kota_Madiun #{@opd.nama_opd}.xlsx"
    render xlsx: "excel_spip", filename: @filename, disposition: "attachment"
  end

  def daftar_resiko; end

  def add_dampak_resiko
    @sasaran = Sasaran.find params[:sasaran_program_opd_id]
    @rincian = @sasaran.rincian
  end

  def cetak_daftar_resiko
    @tahun = params[:tahun] || Time.now.year
    @opd = Opd.find(params[:opd])
    @tahun = @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @program_kegiatans = @opd.program_kegiatans.joins(:sasarans).where(sasarans: { tahun: @tahun }).group(:id)
    @filename = "LAPORAN_DAFTAR_KAK_#{@opd.nama_opd}_TAHUN_#{@tahun}.pdf"
    pdf = DaftarResikoPdf.new(opd: @opd, tahun: @tahun, program_kegiatans: @program_kegiatans)
    send_data(pdf.render, filename: @filename, type: 'application/pdf', disposition: :inline)
  end
end
