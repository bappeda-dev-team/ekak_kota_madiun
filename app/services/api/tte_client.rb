# frozen_string_literal: true

module Api
  class TteClient
    require "http"

    URL      = ENV.fetch("KOMINFO_TTE_URL")
    USERNAME = ENV.fetch("KOMINFO_TTE_USERNAME")
    PASSWORD = ENV.fetch("KOMINFO_TTE_PASSWORD")

    H = HTTP.accept(:json)

    attr_reader :nik, :passphrase, :tte_id

    def initialize(nik, passphrase, tte_id)
      @nik        = nik
      @passphrase = passphrase
      @tte_id     = tte_id
    end

    def generate_tte_docs
      file_io = StringIO.new(tte_document.doc_file.download)

      form_data = {
        file: HTTP::FormData::File.new(file_io, filename: "document.pdf", content_type: "application/pdf"),
        nik: nik,
        passphrase: passphrase,
        tampilan: "invisible"
      }

      request = H.basic_auth(user: USERNAME, pass: PASSWORD)
                 .post("#{URL}/api/sign/pdf", form: form_data)

      parse_response(request)
    end

    private

    def tte_document
      @tte_document ||= TteDocument.find(tte_id)
    end

    def parse_response(response)
      if response.code == 200
        pdf_binary = response.body.to_s

        tte_document.tte_doc_file.attach(
          io: StringIO.new(pdf_binary),
          filename: "tte_signed_#{tte_document.id}_iku_sakip_opd_#{tte_document.kode_opd}.pdf",
          content_type: "application/pdf"
        )

        tte_document.update!(
          status: :signed,
          tte_doc_url: Rails.application.routes.url_helpers.rails_blob_url(
            tte_document.tte_doc_file, only_path: true
          )
        )
      else
        resp = begin
          JSON.parse(response.body)
        rescue StandardError
          {}
        end
        tte_document.update!(
          status: :failed,
          error_message: resp["error"] || "Gagal memproses TTE"
        )
      end

      tte_document
    end
  end
end
