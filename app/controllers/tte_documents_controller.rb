class TteDocumentsController < ApplicationController
  before_action :set_tte_document, only: %i[show edit update destroy status]
  before_action :set_user_opd_tahun, only: %i[new]

  # GET /tte_documents or /tte_documents.json
  def index
    @tte_documents = TteDocument.all
  end

  # GET /tte_documents/1 or /tte_documents/1.json
  def show; end

  def status
    render partial: "tte_documents/status", locals: { tte_document: @tte_document }
  end

  # GET /tte_documents/new
  def new
    @kepala_opd = @opd.user_kepala_opd
    client = Api::SandiDataClient.new(@kepala_opd.nama, @kepala_opd.nik, '')
    @nik_asli = client.decrypt_nik
    @tte_document = TteDocument.new(tahun: @tahun, kode_opd: @kode_opd, user_id: @kepala_opd.id)
    @nik_valid_for_tte = Api::TteClient.new(@nik_asli, '', '').validate_user

    render layout: false
  end

  # POST /tte_documents or /tte_documents.json
  def create
    @tte_document = TteDocument.new(tte_document_params)
    @opd = Opd.find_by(kode_unik_opd: @tte_document.kode_opd)
    @kepala_opd = @opd.user_kepala_opd
    @nik_asli = params[:tte_document][:nik]
    @passphrase = params[:tte_document][:passphrase]

    respond_to do |format|
      if @tte_document.save
        # enqueue job async ke Sidekiq
        GenerateTteDocumentJob.perform_async(
          @nik_asli,
          @passphrase,
          @tte_document.id
        )

        format.json do
          render json: {
            resText: "Dokumen dalam proses tanda tangan elektronik (TTE)",
            status: "pending",
            tte_document_id: @tte_document.id
          }
        end
      else
        @nik_valid_for_tte = Api::TteClient.new(@nik_asli, '', '').validate_user
        format.json do
          render json: {
                   resText: "Gagal membuat dokumen TTE",
                   html_content: html_content(
                     { tte_document: @tte_document },
                     partial: "tte_documents/form.html.erb"
                   )
                 },
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /tte_documents/1 or /tte_documents/1.json
  def destroy
    @tte_document.destroy

    respond_to do |format|
      format.html { redirect_to tte_documents_url, notice: "Tte document was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_user_opd_tahun
    @user = current_user
    @kode_opd = cookies[:opd]
    @tahun = cookies[:tahun]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_tte_document
    @tte_document = TteDocument.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tte_document_params
    params.require(:tte_document).permit(:kode_opd, :tahun, :user_id)
  end
end
