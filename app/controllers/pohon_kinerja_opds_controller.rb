class PohonKinerjaOpdsController < ApplicationController
  def index
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    queries = PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)

    @opd = queries.opd
    @nama_opd = @opd.nama_opd

    @pohon_opd = queries.strategi_kota
    @tacticals = queries.tactical_kota
    @operationals = queries.operational_kota

    @strategi_opd = queries.strategi_opd
    @tactical_opd = queries.tactical_opd
    @operational_opd = queries.operational_opd
  end

  def new_strategic
    @opd = Opd.find_by(kode_unik_opd: cookies[:opd])
    @pohon = StrategiPohon.new(role: 'eselon_2', opd_id: @opd.id)
    @pohon.sasarans.build.indikator_sasarans.build
    render layout: false
  end

  def new_tactical
    @pohon_atasan = StrategiPohon.find(params[:id])
    @pohon = StrategiPohon.new(role: 'eselon_3', opd_id: @pohon_atasan.opd_id, strategi_ref_id: @pohon_atasan.id)
    @pohon.sasarans.build.indikator_sasarans.build
    render layout: false
  end

  def new_operational
    @pohon_atasan = StrategiPohon.find(params[:id])
    @pohon = StrategiPohon.new(role: 'eselon_4', opd_id: @pohon_atasan.opd_id, strategi_ref_id: @pohon_atasan.id)
    @pohon.sasarans.build.indikator_sasarans.build
    render layout: false
  end

  def edit
    # @pohon = Pohon.find_by(pohonable_id: params[:id]).pohonable
    @pohon = StrategiPohon.find(params[:id])
    @url = pohon_kinerja_path(@pohon)
    @method = :patch
    render layout: false
    # render partial: 'form', locals: { pohon: @pohon, url: url, new_strategi: false, method: method }
  end

  def create
    pohon_parameter = pohon_params
    tahun = cookies[:tahun]
    tahun_bener = tahun.match(/murni/) ? tahun[/[^_]\d*/, 0] : tahun
    pohon_parameter[:tahun] = tahun_bener
    @pohon = StrategiPohon.new(pohon_parameter)
    if @pohon.save
      html_content = render_to_string(partial: 'pohon_kinerja/pohon_strategi',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon, jenis: 'Strategi' })
      render json: { resText: "Strategi berhasil dibuat", attachmentPartial: html_content }.to_json,
             status: :created
    else
      error_content = render_to_string(partial: 'pohon_kinerja/form',
                                       formats: 'html',
                                       layout: false,
                                       locals: { model: @pohon, url: pohon_kinerja_index_path, method: :post })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def update
    @pohon = StrategiPohon.find(params[:id])
    if @pohon.update(pohon_params)
      html_content = render_to_string(partial: 'pohon_kinerja/item_pohon',
                                      formats: 'html',
                                      layout: false,
                                      locals: { pohon: @pohon, jenis: 'Strategi' })
      render json: { resText: "Strategi diupdate", attachmentPartial: html_content }.to_json,
             status: :ok
    else
      error_content = render_to_string(partial: 'pohon_kinerja/form_edit',
                                       formats: 'html',
                                       layout: false,
                                       locals: { pohon: @pohon })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json,
             status: :unprocessable_entity
    end
  end

  def destroy
    @pohon = StrategiPohon.find(params[:id])
    @pohon.destroy
    render json: { resText: "Pohon Dihapus", result: true },
           status: :accepted
  end

  private

  def pohon_params
    params.require(:strategi_pohon).permit(:strategi,
                                           :role,
                                           :pohon_id,
                                           :tahun,
                                           :nip_asn,
                                           :opd_id,
                                           :strategi_ref_id,
                                           sasarans_attributes: [:id, :sasaran_kinerja, :id_rencana,
                                                                 indikator_sasarans_params])
  end

  def indikator_sasarans_params
    { indikator_sasarans_attributes: %i[id
                                        indikator_kinerja
                                        aspek
                                        target
                                        satuan
                                        _destroy] }
  end
end
