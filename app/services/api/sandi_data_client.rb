# frozen_string_literal: true

module Api
  # encrypt
  class SandiDataClient
    require 'http'
    require 'openssl'

    URL = ENV.fetch("KOMINFO_ENCRYPT_URL")
    CERT_FILE = Rails.root.join(ENV.fetch("KOMINFO_CERT_FILE"))
    KEY_FILE  = Rails.root.join(ENV.fetch("KOMINFO_KEY_FILE"))

    H = HTTP.accept(:json)

    attr_accessor :nama, :nip,:nik_asli

    def initialize(nama, nip, nik_asli)
      @nama = nama
      @nip = nip
      @nik_asli = nik_asli
    end

    def encrypt_nik
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.cert = OpenSSL::X509::Certificate.new(File.read(CERT_FILE))
      ctx.key  = OpenSSL::PKey.read(File.read(KEY_FILE))

        payload = {
        "Plaintext" => [
            { "Text" => @nik_asli }
        ]
        }
      request = H.post("#{URL}/seal", json:payload, ssl_context: ctx)

      update_detail_pegawai(request)
    end

    def decrypt_nik
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.cert = OpenSSL::X509::Certificate.new(File.read(CERT_FILE))
      ctx.key  = OpenSSL::PKey.read(File.read(KEY_FILE))

      nik_enc = DetailPegawai.find_by(nip: @nip).nik_enc

        payload = {
        "Ciphertext" => [
            { "Text" => nik_enc }
        ]
        }
      request = H.post("#{URL}/unseal", json:payload, ssl_context: ctx)
      get_nik_asli(request)
    end

    def get_nik_asli(response)
      data = JSON.parse(response.body)
      data['Plaintext'][0]['text']
    end

    def update_detail_pegawai(response)
      data = JSON.parse(response.body)
      nik_enc = data['Ciphertext'][0]['text']

      DetailPegawai.upsert(
        {
            nama: @nama,
            nip: @nip,
            nik_enc: nik_enc,
            updated_at: Time.current,
            created_at: Time.current
        },
        unique_by: :index_detail_pegawais_on_nip
      )
    end
  end
end
