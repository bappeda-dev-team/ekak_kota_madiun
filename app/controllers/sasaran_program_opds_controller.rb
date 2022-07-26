class SasaranProgramOpdsController < ApplicationController
  def spip; end

  def excel_spip
    @filename = "SPIP.xlsx"
    render xlsx: "excel_spip", filename: @filename, disposition: "inline"
  end
end
