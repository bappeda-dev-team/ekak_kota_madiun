module Api
  class SkpClient
    require 'http'
    require 'oj'
    URL = 'https://skp.madiunkota.go.id/api'.freeze
    H = HTTP.accept(:json)
    attr_reader :username, :password
    attr_accessor :kode_opd, :bulan, :tahun

    def initialize
      @username = 'bappeda'
      @password = 'bapp7832KH'
      # TODO: dynamic assign this later
      @kode_opd = '2.16.2.20.2.21.04.0000'
      @tahun = 2022
      @bulan = 2
    end

    def data_sasaran_asn_opd
      request(kode_opd, bulan, tahun)
    end

    private

    def request(kode_opd, bulan, tahun)
      response = H.post("#{URL}/sasaran-kinerja-pegawai/#{kode_opd}/#{tahun}/#{bulan}",
                        form: { username: username, password: password })
      data = Oj.load(response.body)
      pegawai = data['data']['data_pegawai']
      pegawai.each do |p|
        p['list_rencana_kinerja'].each do |rencana|
          rencana['list_indikator'].each do |indikator|
            Sasaran.create(
              penerima_manfaat: "#{p['nip']} - #{p['nama']}", # TODO: add column pemilik_sasran
              sasaran_kinerja: rencana['rencana_kerja'],
              indikator_kinerja: indikator['iki'],
              target: indikator['target'],
              satuan: indikator['satuan'],
              user_id: 1 # TODO: Change this from id to NIP
            )
          end
        end
      end
    end
  end
end
