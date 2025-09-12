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
      # 1. generate QR di Tempfile
      qr_tempfile = Tempfile.new(['qr', '.pdf'])
      Prawn::Document.generate(qr_tempfile.path, page_size: 'LEGAL', page_layout: :landscape) do
        qrcode = RQRCode::QRCode.new(qrcode_content)
        png = qrcode.as_png(fill: "white",
                            module_px_size: 6,
                            resize_exactly_to: false,
                            size: 120).to_s
        # pojok kanan bawah, sesuaikan koordinat
        image StringIO.new(png), at: [500, 150], width: 150
      end

      # 2. parse QR PDF
      qr_pdf = CombinePDF.load(qr_tempfile.path)

      # 3. parse PDF asli
      pdf = CombinePDF.parse(pdf_binary)

      # 4. tambahkan footer ke semua halaman
      footer_text = "Dokumen ini telah ditandatangani secara elektronik menggunakan sertifikat elektronik\n" \
                    "yang diterbitkan oleh Balai Besar Sertifikasi Elektronik (BSrE), Badan Siber dan Sandi Negara (BSSN)"
      pdf.pages.each do |page|
        page.textbox(
          footer_text,
          height: 50,
          width: 400,
          y: 5,
          x: 150,
          font_size: 8,
          align: :center
        )
      end

      # 5. merge QR hanya ke halaman terakhir
      last_page = pdf.pages.last
      last_page << qr_pdf.pages[0]

      # 6. simpan final PDF ke Tempfile
      final_tempfile = Tempfile.new(['tte_signed', '.pdf'])
      final_tempfile.binmode
      final_tempfile.write(pdf.to_pdf)
      final_tempfile.rewind

      final_tempfile
    end
  end
end
