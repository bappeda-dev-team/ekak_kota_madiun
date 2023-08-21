class TematiksController < ApplicationController
  before_action :set_tematik, only: %i[show edit update destroy]
  layout false, only: %i[new edit edit_sub]

  # GET /tematiks or /tematiks.json
  def index
    @tematiks = Tematik.all.where(type: nil).order(updated_at: :desc)
  end

  def sub_tematiks
    @sub_tematiks = SubTematik.all.order(updated_at: :desc)
  end

  # GET /tematiks/1 or /tematiks/1.json
  def show; end

  # GET /tematiks/new
  def new
    @tematik = Tematik.new
    @tematik.indikators.build
  end

  def new_sub
    @tematiks = index.collect { |tema| [tema, tema.id] }
    @sub_tematik = SubTematik.new
    @sub_tematik.indikators.build
    render partial: 'form_sub_tematik', locals: { sub_tematik: @sub_tematik }, layout: false
  end

  # GET /tematiks/1/edit
  def edit; end

  # POST /tematiks or /tematiks.json
  def create
    @tematik = Tematik.new(tematik_params)

    respond_to do |format|
      if @tematik.save
        html_content = render_to_string(partial: 'tematiks/tematik',
                                        formats: 'html',
                                        layout: false,
                                        locals: { tematiks: index })
        format.json do
          render json: { resText: "Tematik tersimpan", attachmentPartial: html_content }.to_json, status: :created
        end
      else
        error_content = render_to_string(partial: 'tematiks/form',
                                         formats: 'html',
                                         layout: false,
                                         locals: { tematik: @tematik })
        format.json do
          render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
        end
      end
    end
  end

  def edit_sub
    @sub_tematik = SubTematik.find(params[:id])
    @tematiks = index.collect { |tema| [tema, tema.id] }
  end

  def sub
    @sub_tematik = SubTematik.new(sub_tematik_params)

    if @sub_tematik.save
      html_content = render_to_string(partial: 'tematiks/sub_tematik',
                                      formats: 'html',
                                      layout: false,
                                      locals: { sub_tematiks: sub_tematiks })

      render json: { resText: "Sub Tematik tersimpan", attachmentPartial: html_content }.to_json, status: :created
    else
      error_content = render_to_string(partial: 'tematiks/form_sub_tematik',
                                       formats: 'html',
                                       layout: false,
                                       locals: { sub_tematik: @sub_tematik })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tematiks/1 or /tematiks/1.json
  def update
    respond_to do |format|
      if @tematik.update(tematik_params)
        html_content = render_to_string(partial: 'tematiks/tematik',
                                        formats: 'html',
                                        layout: false,
                                        locals: { tematiks: index })
        format.json do
          render json: { resText: "Tematik diperbarui", res: @tematik, attachmentPartial: html_content }.to_json,
                 status: :ok
        end
      else
        format.json do
          render json: { resText: "Gagal memperbarui", res: @tematik.errors }.to_json, status: :unprocessable_entity
        end
      end
    end
  end

  #
  # PATCH/PUT /tematiks/1 or /tematiks/1.json
  def update_sub
    @sub_tematik = SubTematik.find(params[:id])
    respond_to do |format|
      if @sub_tematik.update(sub_tematik_params)
        html_content = render_to_string(partial: 'tematiks/sub_tematik',
                                        formats: 'html',
                                        layout: false,
                                        locals: { sub_tematiks: sub_tematiks })
        format.json do
          render json: { resText: "Sub Tematik diperbarui", res: @sub_tematik, attachmentPartial: html_content }.to_json,
                 status: :ok
        end
      else
        format.json do
          render json: { resText: "Gagal memperbarui", res: @sub_tematik.errors }.to_json, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /tematiks/1 or /tematiks/1.json
  def destroy
    @tematik.destroy

    respond_to do |format|
      format.html { redirect_to tematiks_url, warning: "Tema dihapus" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tematik
    @tematik = Tematik.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tematik_params
    params.require(:tematik).permit(:tema, :keterangan)
  end

  def sub_tematik_params
    params.require(:sub_tematik).permit(:tema, :keterangan, :tematik_ref_id, :type, indikators_attributes)
  end

  def indikators_attributes
    { indikators_attributes: %i[id kode kode_opd indikator target satuan _destroy] }
  end
end
