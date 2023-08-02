class PohonTematikController < ApplicationController
  include ActionView::RecordIdentifier

  layout false, only: %i[new new_sub edit]

  def new
    tahun = cookies[:tahun]
    @tematiks = Tematik.all.where(type: nil).order(updated_at: :desc)
    @pohon = Pohon.new(pohonable_type: 'Tematik', role: 'pohon_kota', tahun: tahun)
  end

  def new_sub
    parent_pohon = Pohon.find(params[:id])
    @tematik = parent_pohon.pohonable
    @sub_tematiks = @tematik.sub_tematiks.order(updated_at: :desc)
    @pohon = Pohon.new(pohonable_type: 'SubTematik', role: 'sub_pohon_kota', tahun: parent_pohon.tahun,
                       pohon_ref_id: parent_pohon)
  end

  def create
    @pohon = Pohon.new(pohon_params)
    if @pohon.save
      html_content = render_to_string(partial: 'pohon_tematik/pohon_tematik',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Pohon Tematik Dibuat", attachmentPartial: html_content }.to_json, status: :created
    else
      error_content = render_to_string(partial: 'pohon_tematik/form',
                                       formats: 'html',
                                       layout: false,
                                       locals: { pohon: @pohon })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  private

  def pohon_params
    params.require(:pohon).permit(:pohonable_id, :pohonable_type, :role, :tahun, :keterangan)
  end
end
