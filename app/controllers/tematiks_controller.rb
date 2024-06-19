class TematiksController < ApplicationController
  before_action :set_tematik, only: %i[show edit update destroy]
  layout false, only: %i[new edit edit_sub]

  # GET /tematiks or /tematiks.json
  def index
    @tahun = cookies[:tahun]
    @tematiks = Pohon.where(pohonable_type: 'Tematik', tahun: @tahun).map(&:pohonable)
                     .compact
  end

  def sub_tematiks
    @tahun = cookies[:tahun]
    @sub_tematiks = Pohon.where(pohonable_type: 'SubTematik', tahun: @tahun)
                         .map(&:pohonable)
                         .compact_blank
                         .group_by(&:tematik)
                         .compact
  end

  def rad_cetak
    @title = "laporan_rad_sub_tematik"
    @tahun = cookies[:tahun]
    @sub_tematik = SubTematik.find(params[:id])
    pohon_sub = Pohon.find_by(pohonable_id: @sub_tematik.id,
                              pohonable_type: 'SubTematik',
                              tahun: @tahun,
                              role: 'sub_pohon_kota')
    @sasaran_kota = pohon_sub.sub_pohons.where(pohonable_type: 'SubSubTematik',
                                               tahun: @tahun)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@title}_#{@sub_tematik.tematik}_tahun_#{@tahun}",
               dispotition: 'attachment',
               orientation: 'Landscape',
               page_size: 'Legal',
               layout: 'pdf.html.erb',
               template: 'tematiks/rad_cetak.html.erb'
      end
      format.xlsx do
        render filename: "#{@title}_#{@sub_tematik.tematik}_tahun_#{@tahun}"
      end
    end
  end

  # GET /tematiks/1 or /tematiks/1.json
  def show; end

  # GET /tematiks/new
  def new
    @tematik = Tematik.new
    @tematik.indikators.build
  end

  def new_sub
    @tematik = Tematik.find(params[:tematik_ref_id])
    @sub_tematik = SubTematik.new
    @sub_tematik.indikators.build
    render partial: 'form_sub_tematik', locals: { sub_tematik: @sub_tematik }, layout: false
  end

  # GET /tematiks/1/edit
  def edit; end

  # POST /tematiks or /tematiks.json
  def create
    @tematik = Tematik.new(tematik_params)
    tahun = cookies[:tahun]

    respond_to do |format|
      if @tematik.save
        Pohon.create(pohonable_id: @tematik.id, pohonable_type: @tematik.class.name, role: 'pohon_kota', tahun: tahun,
                     keterangan: '-')
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
    @tematik = Tematik.find(sub_tematik_params[:tematik_ref_id])
    @sub_tematik = SubTematik.new(sub_tematik_params)

    if @sub_tematik.save
      tahun = cookies[:tahun]
      pohon_khusus = params[:sub_tematik][:pohon_khusus]
      pohon_tema = Pohon.find_by(pohonable_id: @sub_tematik.tematik_ref_id,
                                 pohonable_type: 'Tematik',
                                 tahun: tahun)
      Pohon.create(pohonable_type: 'SubTematik', pohonable_id: @sub_tematik.id,
                   tahun: tahun,
                   role: 'sub_pohon_kota',
                   pohon_khusus: pohon_khusus,
                   pohon_ref_id: pohon_tema.id)
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
    @tahun = cookies[:tahun]
    @sub_tematik = SubTematik.find(params[:id])
    respond_to do |format|
      if @sub_tematik.update(sub_tematik_params)
        tema_new = @sub_tematik.tematik
        pohon_new = Pohon.find_by(pohonable_type: 'Tematik', tahun: @tahun, pohonable_id: tema_new.id)
        update_pohon = Pohon.find_by(pohonable_type: 'SubTematik', pohonable_id: @sub_tematik.id)
        update_pohon.update(pohon_ref_id: pohon_new.id)
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
    params.require(:tematik).permit(:tema, :keterangan, indikators_attributes)
  end

  def sub_tematik_params
    params.require(:sub_tematik).permit(:tema, :keterangan, :tematik_ref_id, :type, indikators_attributes)
  end

  def indikators_attributes
    { indikators_attributes: %i[id kode kode_opd indikator target satuan tahun _destroy] }
  end
end
