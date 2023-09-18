class PohonKinerjaOpdsController < ApplicationController
  before_action :set_tahun_opd
  before_action :set_strategi_pohon, only: %i[edit update destroy]

  layout false, only: %i[new edit show]

  def index
    @opd = queries.opd
    @nama_opd = @opd.nama_opd

    @strategi_kota = queries.strategi_kota
    @tactical_kota = queries.tactical_kota
    @operational_kota = queries.operational_kota

    @strategi_opd = queries.strategi_opd
    @tactical_opd = queries.tactical_opd
    @operational_opd = queries.operational_opd
    @staff_opd = queries.staff_opd
  end

  def show; end

  def new
    @pohon = StrategiPohon.new(role: 'eselon_2', opd_id: @opd.id)
    @pohon.sasarans.build.indikator_sasarans.build
  end

  def new_child
    @parent = StrategiPohon.find(params[:id])
    @pohon = StrategiPohon.new(role: 'eselon_3', opd_id: @opd.id,
                               strategi_ref_id: @parent.id)
    @pohon.sasarans.build.indikator_sasarans.build
  end

  def edit; end

  def create
    @pohon = StrategiPohon.new(pohon_parameter)
    @pohon.tahun = tahun_fixer
    if @pohon.save
      render json: { resText: "Strategi berhasil dibuat", attachmentPartial: html_content },
             status: :created
    else
      error_content = render_to_string(partial: 'pohon_kinerja/form',
                                       formats: 'html',
                                       layout: false,
                                       locals: { model: @pohon, url: pohon_kinerja_index_path, method: :post })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def html_content(pohon)
    render_to_string(partial: 'pohon_kinerja/pohon_strategi',
                     formats: 'html',
                     layout: false,
                     locals: { pohon: pohon, jenis: 'Strategi' })
  end

  def update
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
    @pohon.destroy
    render json: { resText: "Pohon Dihapus", result: true },
           status: :accepted
  end

  private

  def set_tahun_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @opd = queries.opd
  end

  def set_strategi_pohon
    @pohon = StrategiPohon.find(params[:id])
  end

  def queries
    PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)
  end

  def pohons
    @opd = queries.opd
    @nama_opd = @opd.nama_opd

    @pohon_opd = queries.strategi_kota
    @tacticals = queries.tactical_kota
    @operationals = queries.operational_kota

    @strategi_opd = queries.strategi_opd
    @tactical_opd = queries.tactical_opd
    @operational_opd = queries.operational_opd
  end

  def pohon_params
    params.require(:strategi_pohon).permit(:strategi, :role, :pohon_id, :tahun, :nip_asn,
                                           :opd_id, :strategi_ref_id,
                                           sasarans_attributes: [:id, :sasaran_kinerja, :id_rencana,
                                                                 indikator_sasarans_params])
  end

  def indikator_sasarans_params
    { indikator_sasarans_attributes: %i[id indikator_kinerja aspek target satuan _destroy] }
  end

  def tahun_fixer
    @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
  end
end
