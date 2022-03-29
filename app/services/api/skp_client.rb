# frozen_string_literal: true

module Api
  # Client for SKP API
  class SkpClient
    require 'http'
    require 'oj'
    URL = 'https://skp.madiunkota.go.id/api'
    H = HTTP.accept(:json)
    attr_accessor :kode_opd, :bulan, :tahun

    USERNAME = 'bappeda'
    PASSWORD = 'bapp7832KH'

    def initialize(kode_opd, tahun, bulan)
      # @kode_opd = '2.16.2.20.2.21.04.0000'
      # @tahun = 2022
      # @bulan = 2
      @kode_opd = kode_opd
      @tahun = tahun
      @bulan = bulan
    end

    def data_sasaran_asn_opd
      request = request_skp(kode_opd, tahun, bulan)
      Oj.load(request.body)
    end

    def data_pegawai
      request = request_pegawai(kode_opd, tahun, bulan)
      Oj.load(request.body)
    end

    private

    def request_skp(kode_opd, tahun, bulan)
      H.post("#{URL}/sasaran-kinerja-pegawai/#{kode_opd}/#{tahun}/#{bulan}",
             form: { username: USERNAME, password: PASSWORD })
    end

    def request_pegawai(kode_opd, tahun, bulan)
      H.post("#{URL}/data-pegawai/#{kode_opd}/#{tahun}/#{bulan}",
             form: { username: USERNAME, password: PASSWORD })
    end

    def update_data_sasaran(response) # rubocop:disable Metrics/MethodLength
      data = Oj.load(response.body)
      pegawais = data['data']['data_pegawai']
      pegawais.each do |pegawai|
        pegawai['list_rencana_kinerja'].each do |rencana|
          rencana['list_indikator'].each do |indikator|
            Sasaran.create(
              sasaran_kinerja: rencana['rencana_kerja'],
              indikator_kinerja: indikator['iki'],
              target: indikator['target'],
              satuan: indikator['satuan'],
              nip_asn: pegawai['nip'] # TODO: Change this from id to NIP
            )
          end
        end
      end
    end
  end
end
