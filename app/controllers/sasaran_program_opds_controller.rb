class SasaranProgramOpdsController < ApplicationController
  def spip; end

  def excel_spip
    @filename = "SPIP.xlsx"
    @opd = Opd.find 136
    render xlsx: "excel_spip", filename: @filename, disposition: "inline"
  end
end
