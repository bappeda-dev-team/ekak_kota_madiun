module Api
  class SkpClient
    require 'http'
    require 'oj'
    URL = 'https://skp.madiunkota.go.id/api'.freeze
    H = HTTP.accept(:json)
    attr_reader :username, :password
    attr_accessor :kode_opd, :bulan, :tahun

    def initialize(kode_opd, tahun, bulan)
      @username = 'bappeda'
      @password = 'bapp7832KH'
      # TODO: dynamic assign this later
      @kode_opd = kode_opd
      @tahun = tahun
      @bulan = bulan
      # @kode_opd = '2.16.2.20.2.21.04.0000'
      # @tahun = 2022
      # @bulan = 2
    end

    def data_sasaran_asn_opd
      request(kode_opd, bulan, tahun)
    end

    private

    def request(kode_opd, bulan, tahun)
      H.post("#{URL}/sasaran-kinerja-pegawai/#{kode_opd}/#{tahun}/#{bulan}",
             form: { username: username, password: password })
    end

    def update_data_sasaran(response)
      data = Oj.load(response.body)
      pegawai = data['data']['data_pegawai']
      pegawai.each do |pegawai|
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
