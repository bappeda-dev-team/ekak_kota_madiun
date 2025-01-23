class PohonKinerjaOpdsController < ApplicationController
  before_action :set_tahun_opd
  before_action :set_strategi_pohon, only: %i[edit update destroy]

  layout false, only: %i[new new_child edit show]

  def index
    @opd = queries.opd
    @nama_opd = @opd.nama_opd

    @strategi_kota = queries.strategi_kota.reject { |ph| ph.pohonable.nil? }
    @tactical_kota = queries.tactical_kota
    @operational_kota = queries.operational_kota

    @strategi_beda_opd = queries.pohon_beda_opd

    @strategi_crosscutting = queries.strategi_crosscutting.reject { |ph| ph.pohonable.nil? }

    @strategi_opd = queries.strategi_opd
    @tactical_opd = queries.tactical_opd
    @operational_opd = queries.operational_opd
    @staff_opd = queries.staff_opd

    return if @tahun.nil?

    # TODO: extract to ajax
    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_tahun(tahun_bener)
    @tahun_awal = @periode.tahun_awal.to_i
    @tahun_akhir = @periode.tahun_akhir.to_i
    @tujuan_opds = @opd.tujuan_opds.includes(%i[indikators urusan])
                       .by_periode(tahun_bener)
  end

  def cascading
    @opd = queries.opd
    @nama_opd = @opd.nama_opd

    @strategi_kota = queries.strategi_kota.reject { |ph| ph.pohonable.nil? }
    @tactical_kota = queries.tactical_kota
    @operational_kota = queries.operational_kota

    @strategi_beda_opd = queries.pohon_beda_opd

    @strategi_opd = queries.strategi_opd
    @tactical_opd = queries.tactical_opd
    @operational_opd = queries.operational_opd
    @staff_opd = queries.staff_opd

    @strategi_opds = {
      strategi_opd: @strategi_opd.size,
      tactical_opd: @tactical_opd.size,
      operational_opd: @operational_opd.size,
      staff_opd: @staff_opd.size
    }

    # TODO: extract to ajax
    return if @tahun.nil?

    tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @periode = Periode.find_tahun(tahun_bener)
    @tahun_awal = @periode.tahun_awal.to_i
    @tahun_akhir = @periode.tahun_akhir.to_i
    @tujuan_opds = @opd.tujuan_opds.includes(%i[indikators urusan])
                       .by_periode(tahun_bener)
  end

  def show; end

  def new
    @partial = params[:partial]
    @pohon = StrategiPohon.new(role: 'eselon_2', opd_id: @opd.id)
    @pohon.indikators.build(kode_opd: @opd.kode_unik_opd)
  end

  def new_child
    @partial = params[:partial]
    @title = params[:title]
    @parent = StrategiPohon.find(params[:id])
    @pohon = StrategiPohon.new(role: params[:role], opd_id: @opd.id,
                               strategi_ref_id: @parent.id)
    @pohon.indikators.build(kode_opd: @opd.kode_unik_opd)
  end

  def edit
    @partial = params[:partial]
  end

  def create
    partial = params[:partial]
    @pohon = StrategiPohon.new(pohon_params)
    @pohon.tahun = tahun_fixer
    if @pohon.save
      render json: { resText: "Strategi berhasil dibuat",
                     attachmentPartial: html_content(@pohon, partial) },
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
    partial = params[:partial]
    if @pohon.update(pohon_params.merge(updated_by: current_user.id, updated_at: DateTime.current))
      render json: { resText: "Strategi diupdate",
                     attachmentPartial: html_content(@pohon, partial) }.to_json,
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
    role = @pohon.role
    @pohon.update(role: 'deleted',
                  prev_role: role,
                  deleted_by: current_user.id,
                  deleted_at: DateTime.current)
    if @pohon.strategi_cascade_link.present?
      pokin = Pohon.find_by(pohonable_id: @pohon.strategi_cascade_link)
      pokin.update(status: '',
                   metadata: { processed_by: '', processed_at: '',
                               deleted_by: current_user.id,
                               deleted_at: DateTime.current },
                   strategi_pohon_id: nil)
      pokin.sub_pohons.each do |sub_ph|
        sub_ph.update(status: '',
                      metadata: { processed_by: '', processed_at: '',
                                  deleted_by: current_user.id,
                                  deleted_at: DateTime.current },
                      strategi_pohon_id: nil)
      end
    end
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
                                           :opd_id, :strategi_ref_id, :keterangan,
                                           indikators_attributes)
  end

  def indikators_attributes
    { indikators_attributes: %i[id kode kode_opd indikator target satuan tahun _destroy] }
  end

  def tahun_fixer
    @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
  end
end
