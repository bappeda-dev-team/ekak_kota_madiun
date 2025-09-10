# frozen_string_literal: true

module Api
  # encrypt
  class SandiDataClient
    require 'http'
    require 'openssl'

    URL = ENV.fetch("KOMINFO_ENCRYPT_URL")
    CERT_FILE = ENV.fetch("KOMINFO_CERT_FILE")
    KEY_FILE  = ENV.fetch("KOMINFO_KEY_FILE")

    H = HTTP.accept(:json)

    CTX = OpenSSL::SSL::SSLContext.new
    CTX.cert = OpenSSL::X509::Certificate.new(File.read(CERT_FILE))
    CTX.key  = OpenSSL::PKey.read(File.read(KEY_FILE))

    attr_accessor :nama, :nip, :nik_asli

    def initialize(nama, nip, nik_asli)
      @nama = nama
      @nip = nip
      @nik_asli = nik_asli
    end

    def encrypt_nik
      payload = {
        "Plaintext" => [
          { "Text" => @nik_asli }
        ]
      }
      request = H.post("#{URL}/seal", json: payload, ssl_context: CTX)

      update_detail_pegawai(request)
    end

    def decrypt_nik
      return '' if @nip.blank?

      nik_enc = DetailPegawai.find_by(nip: @nip).nik_enc

      payload = {
        "Ciphertext" => [
          { "Text" => nik_enc }
        ]
      }
      response = H.post("#{URL}/unseal", json: payload, ssl_context: CTX)

      # resp data
      data = JSON.parse(response.body)
      data['Plaintext'][0]['text']
    rescue NoMethodError
      ''
    end

    private

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
