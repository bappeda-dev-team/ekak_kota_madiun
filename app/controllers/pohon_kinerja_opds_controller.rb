class PohonKinerjaOpdsController < ApplicationController
  before_action :set_tahun_opd
  before_action :set_strategi_pohon, only: %i[edit update destroy]

  layout false, only: %i[new new_child edit show]

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

  def cascading
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
    @pohon.indikators.build(kode_opd: @opd.kode_unik_opd)
  end

  def new_child
    @title = params[:title]
    @parent = StrategiPohon.find(params[:id])
    @pohon = StrategiPohon.new(role: params[:role], opd_id: @opd.id,
                               strategi_ref_id: @parent.id)
    @pohon.indikators.build(kode_opd: @opd.kode_unik_opd)
  end

  def edit; end

  def create
    @pohon = StrategiPohon.new(pohon_params)
    @pohon.tahun = tahun_fixer
    if @pohon.save
      render json: { resText: "Strategi berhasil dibuat",
                     attachmentPartial: html_content(@pohon, 'pohon_kinerja_opd') },
             status: :created
    else
      error_content = render_to_string(partial: 'form',
                                       formats: 'html',
                                       layout: false,
                                       locals: { model: @pohon, url: pohon_kinerja_index_path, method: :post })
      render json: { resText: "Gagal Menyimpan", errors: error_content }.to_json, status: :unprocessable_entity
    end
  end

  def update
    @from = params[:from]
    if @pohon.update(pohon_params)
      render json: { resText: "Strategi diupdate",
                     attachmentPartial: html_content(@pohon, 'item_pohon') }.to_json,
             status: :ok
    else
      error_content = render_to_string(partial: 'form_edit',
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

  def html_content(pohon, partial)
    render_to_string(partial: partial,
                     formats: 'html',
                     layout: false,
                     locals: { pohon: pohon })
  end

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
                                           indikators_attributes)
  end

  def indikators_attributes
    { indikators_attributes: %i[id kode kode_opd indikator target satuan tahun _destroy] }
  end

  def tahun_fixer
    @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
  end
end
