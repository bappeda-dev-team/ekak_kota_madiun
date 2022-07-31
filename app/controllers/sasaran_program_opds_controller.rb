class SasaranProgramOpdsController < ApplicationController
  def spip; end

  def excel_spip
    @filename = "SPIP.xlsx"
    @opd = Opd.find 136
    render xlsx: "excel_spip", filename: @filename, disposition: "inline"
  end

  def daftar_resiko; end

  def add_dampak_resiko
    @sasaran = Sasaran.find params[:sasaran_program_opd_id]
    @rincian = @sasaran.rincian
  end
end
