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
        tampilan: "invisible",
        jenis_response: "BASE64"
      }

      request = H.basic_auth(user: USERNAME, pass: PASSWORD)
                 .post("#{URL}/api/sign/pdf", form: form_data)

      parse_response(request)
    end

    private

    def tte_document
      @tte_document ||= TteDocument.find(tte_id)
    end

    def parse_response_noqr(response)
      if response.code == 200
        data = JSON.parse(response.body)

        # 1. decode PDF dari base64
        pdf_binary = Base64.decode64(data["base64_signed_file"])

        # 2. attach sementara ke ActiveStorage agar bisa generate URL
        tte_document.tte_doc_file.attach(
          io: StringIO.new(pdf_binary),
          filename: "tte_signed_iku_sakip_opd_#{tte_document.kode_opd}.pdf",
          content_type: "application/pdf"
        )

        # 6. update record
        tte_document.update!(
          status: :signed,
          error_message: '',
          id_dokumen: data['id_dokumen'],
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

    def parse_response(response)
      if response.code == 200
        data = JSON.parse(response.body)

        # 1. decode PDF dari base64
        pdf_binary = Base64.decode64(data["base64_signed_file"])

        # 2. attach sementara ke ActiveStorage agar bisa generate URL
        tte_document.tte_doc_file.attach(
          io: StringIO.new(pdf_binary),
          filename: "tte_signed_iku_sakip_opd_#{tte_document.kode_opd}.pdf",
          content_type: "application/pdf"
        )

        # 3. generate URL untuk QR
        pdf_url = Rails.application.routes.url_helpers.rails_blob_url(
          tte_document.tte_doc_file, only_path: false
        )

        # 4. tambah footer + QR
        final_pdf_binary = add_qr_and_footer(pdf_binary, pdf_url)

        # 5. purge dan attach final PDF
        tte_document.tte_doc_file.purge
        tte_document.tte_doc_file.attach(
          io: final_pdf_binary,
          filename: "tte_signed_iku_sakip_opd_#{tte_document.kode_opd}.pdf",
          content_type: "application/pdf"
        )

        # 6. update record
        tte_document.update!(
          status: :signed,
          error_message: '',
          id_dokumen: data['id_dokumen'],
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

    def add_qr_and_footer(pdf_binary, qrcode_content)
      # 1. load dokumen signed (TTE) dalam mode incremental
      doc = HexaPDF::Document.new(io: StringIO.new(pdf_binary))

      # 2. generate QR ke image IO
      qrcode = RQRCode::QRCode.new(qrcode_content)
      png_data = qrcode.as_png(
        fill: 'white',
        module_px_size: 6,
        size: 120
      ).to_s
      qr_io = StringIO.new(png_data)

      # 3. embed QR image
      qr_image = doc.images.add(qr_io)

      # 4. siapkan footer text
      footer_text = "Dokumen ini telah ditandatangani secara elektronik menggunakan sertifikat elektronik\n" \
                    "yang diterbitkan oleh Balai Besar Sertifikasi Elektronik (BSrE), Badan Siber dan Sandi Negara (BSSN)"

      tl = HexaPDF::Layout::TextLayouter.new

      doc.pages.each_with_index do |page, idx|
        canvas = page.canvas(type: :overlay) # gunakan overlay agar tidak overwrite konten lama

        # footer
        canvas.font("Helvetica", size: 8)
        canvas.text(footer_text, at: [100, 30])

        tl.style.text_align(:center).text_valign(:bottom)
        # hanya halaman terakhir yang ditempeli QR
        canvas.image(qr_image, at: [page.box.width - 470, 100], width: 120) if idx == doc.pages.count - 1
      end

      # 5. tulis ulang sebagai incremental update
      final_tempfile = Tempfile.new(['tte_signed', '.pdf'])
      final_tempfile.binmode
      doc.write(final_tempfile, incremental: true) # <--- penting!
      final_tempfile.rewind

      final_tempfile
    end
  end
end
