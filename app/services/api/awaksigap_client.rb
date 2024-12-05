module Api
  class AwaksigapClient
    require 'http'
    require 'oj'
    URL = 'https://awaksigap.madiunkota.go.id/api'.freeze
    H = HTTP.accept(:json)

    USERNAME = ENV.fetch("AWAKSIGAP_CLIENT_USERNAME")
    PASSWORD = ENV.fetch("AWAKSIGAP_CLIENT_PASSWORD")

    def initialize(url: 'inovasi/get/all')
      @inovasi_url = url
    end

    def update_inovasi_masyarakat
      request = H.post("#{URL}/#{@inovasi_url}",
                       form: { username: USERNAME, password: PASSWORD })
      update_data_inovasi(request)
    end

    private

    def update_data_inovasi(response)
      data = JSON.parse(response.body)
      status = data['status']
      pelapors = data['data']

      return unless status == 'success'

      data_pelapor = pelapors.map do |pelapor|
        {
          nama_pelapor: pelapor['namapelapor'],
          no_whatsapp: pelapor['nowa'],
          alamat: pelapor['alamat'],
          email_pelapor: pelapor['email'],
          inovasi: pelapor['isi_inovasi'],
          gambaran_nilai_kebaruan: pelapor['nilai_kebaruan'],
          status_laporan: pelapor['status_ajuan'],
          id_tiket: pelapor['id_tiket'],
          created_at: Time.now,
          updated_at: Time.now
        }
      end

      return unless data_pelapor.any?

      InovasiMasyarakat.upsert_all(data_pelapor, unique_by: :id_tiket)
    end
  end
end
