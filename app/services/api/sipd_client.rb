module Api
  class SipdClient
    require 'http'
    require 'oj'

    URL = 'http://10.11.15.120:8888'.freeze
    H = HTTP.accept(:json)

    attr_accessor :id_sipd, :bulan, :tahun

    def initialize
      # TODO: dynamic assign this later
      @id_sipd = '474'
      @tahun = 2022
    end

    def list_opd
      response = H.get("#{URL}/list_opd_get/109").to_s
      result = JSON.parse(response, object_class: OpenStruct)
      result.data
    end

    def sub_kegiatan_detail
      response = H.get("#{URL}/get_komponen_all/109?tahun=#{tahun}&id_sub_skpd=#{id_sipd}")
      response.parse['data']
    end
  end
end
