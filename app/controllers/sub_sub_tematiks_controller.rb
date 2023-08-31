class SubSubTematiksController < TematiksController
  def create
    @sub_sub_tematik = SubSubTematik.new(sub_sub_tematik_params)
    tahun = cookies[:tahun]

    if @sub_sub_tematik.save
      @pohon = Pohon.create(pohonable_id: @sub_sub_tematik.id,
                            pohonable_type: @sub_sub_tematik.class.name,
                            role: 'sub_sub_pohon_kota',
                            tahun: tahun,
                            keterangan: @sub_sub_tematik.keterangan)
      render json: { resText: "Pohon Sub Sub-Tematik Dibuat",
                     attachmentPartial: html_content('pohon_tematik/pohon_sub_sub_tematik') }.to_json,
             status: :created
    else
      error_content = render_to_string(partial: 'pohon_tematik/form_sub_sub_tematik',
                                       formats: 'html',
                                       layout: false,
                                       locals: { pohon: @pohon })
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

  private

  def html_content(partial)
    render_to_string(partial: partial,
                     formats: 'html',
                     layout: false,
                     locals: { pohon: @pohon })
  end

  def sub_sub_tematik_params
    params.require(:sub_sub_tematik).permit(:tema, :keterangan, :tematik_ref_id, :type, indikators_attributes)
  end

  def indikators_attributes
    { indikators_attributes: %i[id kode kode_opd indikator target satuan _destroy] }
  end
end
