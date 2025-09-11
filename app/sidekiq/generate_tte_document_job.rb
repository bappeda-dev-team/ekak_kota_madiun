class GenerateTteDocumentJob
  include Sidekiq::Job

  def perform(nik, passphrase, tte_id)
    # generate document dulu
    data_tte = TteDocument.find(tte_id)

    # jangan generate jika sudah ada doc_file
    unless data_tte.doc_file.attached?

      pdf_non_tte = IkuSakipPdf.new(
        tahun: data_tte.tahun,
        kode_opd: data_tte.kode_opd
      ).generate

      # backup file non tte
      data_tte.doc_file.attach(
        io: StringIO.new(pdf_non_tte),
        filename: "non_tte_#{tte_id}.pdf",
        content_type: "application/pdf"
      )
      data_tte.update!(
        status: :pending,
        doc_url: Rails.application.routes.url_helpers.rails_blob_url(
          data_tte.doc_file, only_path: true
        )
      )
    end

    client = Api::TteClient.new(
      nik,
      passphrase,
      tte_id
    )
    client.generate_tte_docs
  end
end
