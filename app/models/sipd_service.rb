# frozen_string_literal: true

# get sipd data
# mockuped using postman
class SipdService
  require 'http'
  END_POINT = Rails.application.credentials.sipd_url # list all opd
  H = HTTP.accept(:json)

  def list_opd
    response = H.get("#{END_POINT}/list_opd_get/109").to_s
    result = JSON.parse(response, object_class: OpenStruct)
    result.data
  end

  def program_kegiatan(kode_opd)
    response = H.get("#{END_POINT}/get_komponen_all/109?tahun=2022&id_sub_skpd=#{kode_opd}")
    response.parse['data']
  end
end
