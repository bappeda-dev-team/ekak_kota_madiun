class PohonTematikController < ApplicationController
  include ActionView::RecordIdentifier

  layout false

  def index
    @tahun = cookies[:tahun]
    tematik_id = params[:tematik]

    @pohon = PohonTematikQueries.new(tahun: @tahun)

    @tematik = Tematik.find(tematik_id)

    @tematik_kota = Pohon.where(pohonable_type: 'Tematik',
                                pohonable_id: tematik_id,
                                tahun: @tahun,
                                role: 'pohon_kota')
                         .includes(:pohonable)
    return if @tematik_kota.empty?

    @sub_tematik_kota = @pohon.sub_tematiks
    @sub_sub_tematik_kota = @pohon.sub_sub_tematiks
    @strategi_tematiks = @pohon.strategi_tematiks
    @tactical_tematiks = @pohon.tactical_tematiks
    @operational_tematiks = @pohon.operational_tematiks
  end

  def new
    tahun = cookies[:tahun]
    @tematiks = Tematik.where(type: nil).order(updated_at: :desc)
                       .collect { |tema| [tema.tema, tema.id] }
    @pohon = Pohon.new(pohonable_type: 'Tematik', role: 'pohon_kota', tahun: tahun)
  end

  def edit
    @pohon = Pohon.find(params[:id])
    @tematiks = Tematik.where(type: nil).order(updated_at: :desc)
                       .collect { |tema| [tema.tema, tema.id] }
  end

  def new_sub
    parent_pohon = Pohon.find(params[:id])
    @tematik = parent_pohon.pohonable
    @sub_tematiks = @tematik.sub_tematiks.order(updated_at: :desc)
    @pohon = Pohon.new(pohonable_type: 'SubTematik', role: 'sub_pohon_kota', tahun: parent_pohon.tahun,
                       pohon_ref_id: parent_pohon.id)
  end

  def edit_sub_tematik
    @pohon = Pohon.find(params[:id])
    @tematik = Pohon.find(@pohon.pohon_ref_id).pohonable
    @tematiks = [@tematik.id, @tematik.tema]
    @sub_tematik = @pohon.pohonable
    @sub_tematiks = @tematik.sub_tematiks.order(updated_at: :desc).collect { |sub_tema| [sub_tema.tema, sub_tema.id] }
  end

  def pindah_sub_tematik
    @pohon = Pohon.find(params[:id])
    @tahun = @pohon.tahun
    @dahan_atas = Pohon.where(pohonable_type: 'Tematik', role: 'pohon_kota', tahun: @tahun)
                       .collect { |dahan| [dahan.pohonable.tema, dahan.id] }
  end

  def update_sub_tematik
    @pohon = Pohon.find(params[:id])
    @sub_tematik = @pohon.pohonable
    if @sub_tematik.update(sub_tematik_params)
      html_content = render_to_string(partial: 'pohon_tematik/item_pohon_sub_tematik',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { restext: "sub-tematik diupdate", attachmentPartial: html_content }.to_json, status: :ok
    else
      render json: { resText: "Gagal Menyimpan" }.to_json, status: :unprocessable_entity
    end
  end

  def pindah_pohon
    @pohon = Pohon.find(params[:id])
    if @pohon.update(pohon_sub_tema_params)
      render json: { resText: "Jalur di-ubah" }.to_json,
             status: :ok
    else
      render json: { resText: "Gagal Menyimpan" }.to_json, status: :unprocessable_entity
    end
  end

  def new_strategi_tematik
    tahun = cookies[:tahun]
    parent_pohon = Pohon.find(params[:id])
    @opds = Opd.opd_resmi
    @strategis = StrategiPohon.where(tahun: tahun, role: 'eselon_2')
    @pohon = Pohon.new(pohonable_type: 'Strategi',
                       role: 'strategi_pohon_kota',
                       tahun: parent_pohon.tahun,
                       pohon_ref_id: parent_pohon.id)
  end

  def new_strategi
    parent_pohon = Pohon.find(params[:id])
    @pohon_ref_id = params[:id]
    @opds = Opd.opd_resmi
    @strategi = Strategi.new(role: 'strategi_pohon_kota', tahun: parent_pohon.tahun, type: nil)
    @strategi.indikators.build
  end

  def edit_strategi
    @pohon = Pohon.find(params[:id])
    @strategi = @pohon.pohonable
    @opds = Opd.opd_resmi
  end

  def create_strategi_tematik
    new_params = pohon_strategi_tema_params.merge(metadata: { submitted_by: current_user.id,
                                                              submitted_at: DateTime.current })
    @pohon = Pohon.new(new_params)
    if @pohon.save
      html_content = render_to_string(partial: 'pohon_tematik/pohon_strategi_tematik',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Strategi Tematik Ditambahkan", attachmentPartial: html_content }.to_json,
             status: :created
    else
      error_content = render_to_string(partial: 'pohon_tematik/form_strategi_tematik',
                                       formats: 'html',
                                       layout: false,
                                       locals: { pohon: @pohon })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def update_strategi
    @pohon = Pohon.find(params[:id])
    keterangan = params[:strategi][:keterangan]
    @strategi = @pohon.pohonable
    if @strategi.update(strategi_params)
      @pohon.update(keterangan: keterangan)
      html_content = render_to_string(partial: 'pohon_tematik/item_pohon_strategi',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Strategi Tematik Diupdate", attachmentPartial: html_content }.to_json,
             status: :ok
    else
      error_content = render_to_string(partial: 'pohon_tematik/form_strategi_tematik',
                                       formats: 'html',
                                       layout: false,
                                       locals: { pohon: @pohon })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def terima
    @pohon = Pohon.find(params[:id])
    if @pohon.update(status: 'diterima', metadata: { processed_by: current_user.id, processed_at: DateTime.current })
      html_content = render_to_string(partial: 'pohon_kinerja_opds/item_pohon',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Strategi diterima", attachmentPartial: html_content }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan" }.to_json,
             status: :unprocessable_entity
    end
  end

  def tolak_strategi
    @pohon = Pohon.find(params[:id])
  end

  def tolak
    keterangan_tolak = params[:pohon][:keterangan_tolak]
    @pohon = Pohon.find(params[:id])
    if @pohon.update(status: 'ditolak',
                     metadata: {
                       processed_by: current_user.id,
                       processed_at: DateTime.current,
                       keterangan: keterangan_tolak
                     })
      html_content = render_to_string(partial: 'pohon_kinerja_opds/item_pohon',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Usulan ditolak", attachmentPartial: html_content }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan" }.to_json,
             status: :unprocessable_entity
    end
  end

  def create_strategi_tematik_baru
    @strategi = Strategi.new(strategi_params)
    if @strategi.save
      @pohon = new_pohon!
      html_content = render_to_string(partial: 'pohon_tematik/pohon_strategi_tematik',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Strategi Tematik Ditambahkan", attachmentPartial: html_content }.to_json,
             status: :created
    else
      error_content = render_to_string(partial: 'pohon_tematik/form_strategi_tematik_baru',
                                       formats: 'html',
                                       layout: false,
                                       locals: { strategi: @strategi })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def new_tactical_tematik
    tahun = cookies[:tahun]
    parent_pohon = Pohon.find(params[:id])
    @opd = parent_pohon.opd
    @strategis = StrategiPohon.where(tahun: tahun, role: 'eselon_3', opd_id: @opd.id)
    # @strategis = @opd.strategis.where(tahun: parent_pohon.tahun, role: 'eselon_3', type: nil)
    @pohon = Pohon.new(pohonable_type: 'Strategi', role: 'tactical_pohon_kota', tahun: parent_pohon.tahun,
                       opd_id: @opd.id,
                       pohon_ref_id: parent_pohon.id)
  end

  def new_tactical
    parent_pohon = Pohon.find(params[:id])
    @pohon_ref_id = params[:id]
    @opd = parent_pohon.opd
    @tactical = Strategi.new(role: 'tactical_pohon_kota', tahun: parent_pohon.tahun,
                             opd_id: @opd.id)
    @tactical.indikators.build(kode_opd: @opd.kode_unik_opd)
  end

  def edit_tactical
    @pohon = Pohon.find(params[:id])
    @opds = Opd.opd_resmi
    @strategi = @pohon.pohonable
  end

  def update_tactical
    @pohon = Pohon.find(params[:id])
    keterangan = params[:strategi][:keterangan]
    @strategi = @pohon.pohonable
    if @strategi.update(strategi_params)
      @pohon.update(keterangan: keterangan)
      html_content = render_to_string(partial: 'pohon_tematik/item_pohon_tactical',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Tactical Tematik Diupdate", attachmentPartial: html_content }.to_json,
             status: :created
    else
      error_content = render_to_string(partial: 'pohon_tematik/form_strategi_tematik',
                                       formats: 'html',
                                       layout: false,
                                       locals: { pohon: @pohon })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def new_operational_tematik
    tahun = cookies[:tahun]
    parent_pohon = Pohon.find(params[:id])
    @opd = parent_pohon.opd
    @strategis = StrategiPohon.where(tahun: tahun, role: 'eselon_4', opd_id: @opd.id)
    # @strategis = @opd.strategis.where(tahun: parent_pohon.tahun, role: 'eselon_4', type: nil)
    @pohon = Pohon.new(pohonable_type: 'Strategi', role: 'operational_pohon_kota', tahun: parent_pohon.tahun,
                       opd_id: @opd.id,
                       pohon_ref_id: parent_pohon.id)
  end

  def new_operational
    parent_pohon = Pohon.find(params[:id])
    @pohon_ref_id = params[:id]
    @opd = parent_pohon.opd
    @operational = Strategi.new(role: 'operational_pohon_kota', tahun: parent_pohon.tahun,
                                opd_id: @opd.id)
    @operational.indikators.build(kode_opd: @opd.kode_unik_opd)
  end

  def edit_operational
    @pohon = Pohon.find(params[:id])
    @strategi = @pohon.pohonable
    @opds = Opd.opd_resmi
  end

  def update_operational
    @pohon = Pohon.find(params[:id])
    keterangan = params[:strategi][:keterangan]
    @strategi = @pohon.pohonable
    if @strategi.update(strategi_params)
      @pohon.update(keterangan: keterangan)
      html_content = render_to_string(partial: 'pohon_tematik/item_pohon_operational',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Operational Tematik Diupdate", attachmentPartial: html_content }.to_json,
             status: :created
    else
      error_content = render_to_string(partial: 'pohon_tematik/form_strategi_tematik',
                                       formats: 'html',
                                       layout: false,
                                       locals: { pohon: @pohon })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def create
    new_params = pohon_params.merge(metadata: { submitted_by: current_user.id, submitted_at: DateTime.current })
    @pohon = Pohon.new(new_params)
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

  def update
    @pohon = Pohon.find(params[:id])
    if @pohon.update(pohon_params)
      html_content = render_to_string(partial: 'pohon_tematik/item_pohon_tematik',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Pohon Tematik Diupdate", attachmentPartial: html_content }.to_json, status: :created
    else
      error_content = render_to_string(partial: 'pohon_tematik/form',
                                       formats: 'html',
                                       layout: false,
                                       locals: { pohon: @pohon })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def create_sub_tema
    new_params = pohon_sub_tema_params.merge(metadata: { submitted_by: current_user.id,
                                                         submitted_at: DateTime.current })
    @pohon = Pohon.new(new_params)
    if @pohon.save
      html_content = render_to_string(partial: 'pohon_tematik/pohon_sub_tematik',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Pohon Sub-Tematik Dibuat", attachmentPartial: html_content }.to_json, status: :created
    else
      error_content = render_to_string(partial: 'pohon_tematik/form_sub_tematik',
                                       formats: 'html',
                                       layout: false,
                                       locals: { pohon: @pohon })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def new_sub_sub
    @pohon_sub = params[:id]
    pohon = Pohon.find(params[:id])
    @sub_tematik = pohon.pohonable_id
    @sub_sub_tematik = SubSubTematik.new(tematik_ref_id: @sub_tematik)
    @sub_sub_tematik.indikators.build
  end

  def edit_sub_sub
    pohon_sub_sub = Pohon.find(params[:id])
    @pohon_sub = pohon_sub_sub.pohon_ref_id
    @sub_sub_tematik = pohon_sub_sub.pohonable
  end

  def create_sub_sub_tema
    new_params = pohon_sub_tema_params.merge(metadata: { submitted_by: current_user.id,
                                                         submitted_at: DateTime.current })
    @pohon = Pohon.new(new_params)
    if @pohon.save
      html_content = render_to_string(partial: 'pohon_tematik/pohon_sub_sub_tematik',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Pohon Sub Sub-Tematik Dibuat", attachmentPartial: html_content }.to_json,
             status: :created
    else
      error_content = render_to_string(partial: 'pohon_tematik/form_sub_sub_tematik',
                                       formats: 'html',
                                       layout: false,
                                       locals: { pohon: @pohon })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def create_tactical_tematik
    new_params = pohon_strategi_tema_params.merge(metadata: { submitted_by: current_user.id,
                                                              submitted_at: DateTime.current })
    @pohon = Pohon.new(new_params)
    if @pohon.save
      html_content = render_to_string(partial: 'pohon_tematik/pohon_tactical_tematik',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Tactical Tematik Ditambahkan", attachmentPartial: html_content }.to_json,
             status: :created
    else
      error_content = render_to_string(partial: 'pohon_tematik/form_tactical_tematik',
                                       formats: 'html',
                                       layout: false,
                                       locals: { pohon: @pohon })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def create_tactical_tematik_baru
    @strategi = Strategi.new(strategi_params)
    if @strategi.save
      @pohon = new_pohon!
      html_content = render_to_string(partial: 'pohon_tematik/pohon_tactical_tematik',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Tactical Tematik Ditambahkan", attachmentPartial: html_content }.to_json,
             status: :created
    else
      error_content = render_to_string(partial: 'pohon_tematik/form_tactical_tematik_baru',
                                       formats: 'html',
                                       layout: false,
                                       locals: { strategi: @strategi })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def create_operational_tematik
    new_params = pohon_strategi_tema_params.merge(metadata: { submitted_by: current_user.id,
                                                              submitted_at: DateTime.current })
    @pohon = Pohon.new(new_params)
    if @pohon.save
      html_content = render_to_string(partial: 'pohon_tematik/pohon_operational_tematik',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Operational Tematik Ditambahkan", attachmentPartial: html_content }.to_json,
             status: :created
    else
      error_content = render_to_string(partial: 'pohon_tematik/form_operational_tematik',
                                       formats: 'html',
                                       layout: false,
                                       locals: { pohon: @pohon })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def create_operational_tematik_baru
    @strategi = Strategi.new(strategi_params)
    if @strategi.save
      @pohon = new_pohon!
      html_content = render_to_string(partial: 'pohon_tematik/pohon_operational_tematik',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon })
      render json: { resText: "Operational Tematik Ditambahkan", attachmentPartial: html_content }.to_json,
             status: :created
    else
      error_content = render_to_string(partial: 'pohon_tematik/form_operational_tematik_baru',
                                       formats: 'html',
                                       layout: false,
                                       locals: { strategi: @strategi })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def destroy
    @pohon = Pohon.find(params[:id])
    childs = Pohon.where(pohon_ref_id: @pohon.id)
    childs.destroy_all
    @pohon.destroy

    render json: { resText: "Dihapus" }.to_json, status: :accepted
  end

  private

  def new_pohon_params
    @tahun = params[:strategi][:tahun]
    @role = params[:strategi][:role]
    @pohon_ref_id = params[:strategi][:pohon_ref_id]
    @opd_id = params[:strategi][:opd_id]
    @keterangan = params[:strategi][:keterangan]
  end

  def new_pohon!
    new_pohon_params
    Pohon.create!(pohonable_type: 'Strategi', pohonable_id: @strategi.id,
                  role: @role, tahun: @tahun,
                  keterangan: @keterangan,
                  pohon_ref_id: @pohon_ref_id, opd_id: @opd_id,
                  metadata: { submitted_by: current_user.id,
                              submitted_at: DateTime.current })
  end

  def pohon_params
    params.require(:pohon).permit(:pohonable_id, :pohonable_type, :role, :tahun, :keterangan)
  end

  def pohon_sub_tema_params
    params.require(:pohon).permit(:pohonable_id, :pohonable_type, :role, :tahun, :keterangan, :pohon_ref_id)
  end

  def pohon_strategi_tema_params
    params.require(:pohon).permit(:pohonable_id, :pohonable_type, :role, :tahun,
                                  :opd_id,
                                  :keterangan, :pohon_ref_id)
  end

  def strategi_params
    params.require(:strategi).permit(:role, :tahun,
                                     :strategi, :opd_id,
                                     indikators_attributes)
  end

  def sub_tematik_params
    params.require(:sub_tematik).permit(:tema, :keterangan, :tematik_ref_id, :type, indikators_attributes)
  end

  def indikators_attributes
    { indikators_attributes: %i[id kode kode_opd indikator target satuan tahun _destroy] }
  end
end
