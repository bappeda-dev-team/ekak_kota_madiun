class IndikatorsController < ApplicationController
  before_action :set_indikator, only: %i[show edit update destroy]
  layout false, only: %i[new edit new_indikator_rb edit_target_iku]

  def rpjp_makro
    @tahun = cookies[:tahun]

    # tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun

    @rpjp_makro = Indikator.rpjp_makro.where(tahun: @tahun).includes(:targets)
  end

  def rpjp_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)

    # tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun

    @rpjp_makro = Indikator.rpjp_makro.where(tahun: @tahun, kode_opd: @kode_opd)
                           .includes(:targets)
  end

  def rpjmd_makro
    @tahun = cookies[:tahun]

    # tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun

    @rpjmd_makro = Indikator.rpjmd_makro.where(tahun: @tahun).includes(:targets)
  end

  def rkpd_makro
    @tahun = cookies[:tahun]

    # tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun

    @rkpd_makro = Indikator.rkpd_makro.where(tahun: @tahun).includes(:targets)
  end

  def rkpd_tujuan
    @tahun = cookies[:tahun]

    # tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun

    tematiks = PohonTematikQueries.new(tahun: @tahun)

    @tujuan_kota = tematiks.tematiks.map(&:pohonable).compact_blank
  end

  def rkpd_sasaran
    @tahun = cookies[:tahun]

    # tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun

    tematiks = PohonTematikQueries.new(tahun: @tahun)

    sub_tematiks = tematiks.sub_tematiks.map(&:pohonable).compact_blank
    sub_sub_tematiks = tematiks.sub_sub_tematiks.map(&:pohonable).compact_blank
    @sasaran_kota = sub_tematiks + sub_sub_tematiks
  end

  def rkpd_program
    @tahun = cookies[:tahun]

    # tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun

    @program_kota = ProgramKegiatan.programs.group_by(&:opd)
  end

  def iku_kota
    @tahun = cookies[:tahun]

    tematiks = PohonTematikQueries.new(tahun: @tahun)

    tujuan_kota = tematiks.tematiks.map(&:pohonable).compact_blank
    sasaran_kota = tematiks.sub_tematiks.map(&:pohonable).compact_blank
    iku_kota = tujuan_kota + sasaran_kota
    @iku_kota = iku_kota.map(&:indikators).compact_blank.flatten
  end

  # GET /indikators/renja_opd
  def renja_opd; end

  # POST /indikators/item_renja_opd -> ajax page from renja_opd
  def item_renja_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd
    @program_kegiatans = opd.program_renstra

    render layout: false
  end

  def tujuan_renja_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]

    @tahun_bener = @tahun&.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun

    pokin_opd = PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)

    opd = pokin_opd.opd
    @nama_opd = opd.nama_opd

    @tujuan_opd = opd.tujuan_opds.by_periode(@tahun_bener)
  end

  def sasaran_renja_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]

    pohon_kinerja = PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)
    opd = pohon_kinerja.opd
    @nama_opd = opd.nama_opd
    @sasarans_opd = pohon_kinerja.strategi_opd.map(&:sasarans).flatten.compact_blank
  end

  def program_renja_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]

    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd
    @programs = opd.program_renstra
  end

  def kegiatan_renja_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]

    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd
    @kegiatans = opd.kegiatans_renstra
  end

  def subkegiatan_renja_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]

    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd
    @subkegiatans = opd.subkegiatans_renstra
  end

  def iku_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]

    @tahun_bener = @tahun&.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun

    pokin_opd = PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)

    opd = pokin_opd.opd
    @nama_opd = opd.nama_opd

    tujuan_opd = opd.tujuan_opds
                    .by_periode(@tahun_bener)
    sasaran_opd = pokin_opd.strategi_opd.map(&:sasarans).flatten.compact_blank
    iku_opd = tujuan_opd + sasaran_opd
    @iku_opd = iku_opd.map(&:indikators).compact_blank.flatten
  end

  def lppd_outcome
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @lppd_outcome = Indikator.lppd_outcome.where(tahun: @tahun)
  end

  def lppd_output
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @lppd_output = Indikator.lppd_output.where(tahun: @tahun)
  end

  def spm_outcome
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @spm_outcome = Indikator.spm_outcome.where(tahun: @tahun)
  end

  def spm_output
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @spm_output = Indikator.spm_output.where(tahun: @tahun)
  end

  def sdgs_outcome
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @sdgs_outcome = Indikator.sdgs_outcome.where(tahun: @tahun)
  end

  def sdgs_output
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @sdgs_output = Indikator.sdgs_output.where(tahun: @tahun)
  end

  def rb_outcome
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @rb_outcome = Indikator.rb_outcome.where(tahun: @tahun)
  end

  def rb_output
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    @rb_output = Indikator.rb_output.where(tahun: @tahun)
  end

  # GET /indikators or /indikators.json
  def index
    handle_filters
  end

  # GET /indikators/1 or /indikators/1.json
  def show; end

  # GET /indikators/new
  def new
    @opds = Opd.opd_resmi_kota
               .pluck(:nama_opd,
                      :kode_unik_opd)
    @indikator = Indikator.new(new_indikator_params)
  end

  # GET /indikators/1/edit
  def edit
    @opds = Opd.opd_resmi_kota
               .pluck(:nama_opd,
                      :kode_unik_opd)
  end

  # POST /indikators or /indikators.json
  def create
    @indikator = Indikator.new(indikator_params)

    if @indikator.save
      render json: { resText: 'Indikator ditambahkan',
                     html_content: html_content({ indikator: @indikator },
                                                partial: 'indikators/indikator') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ indikator: @indikator },
                                                 partial: 'indikators/form').to_json }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /indikators/1 or /indikators/1.json
  def update
    if @indikator.update(indikator_params)
      render json: { resText: 'Perubahan disimpan',
                     html_content: html_content({ indikator: @indikator },
                                                partial: 'indikators/indikator') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ indikator: @indikator },
                                                 partial: 'indikators/form').to_json }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /indikators/1 or /indikators/1.json
  def destroy
    @indikator.destroy

    render json: { resText: "Indikator Dihapus" }.to_json, status: :accepted
  end

  def import
    return redirect_to request.referer, error: 'File belum dipilih' if params[:file].nil?

    redirect_to request.referer, warning: 'Upload File CSV' unless params[:file].content_type == 'text/csv'

    import_errors = CsvImportService.new.call(params[:file])

    if import_errors.nil?
      redirect_to request.referer, success: 'Import Selesai'
    else
      redirect_to request.referer, error: 'Tejadi kesalahan, data tidak sesuai'
    end
  end

  # rubocop: disable Metrics
  def edit_target_iku
    periode = params[:periode].split('-')
    @tahun_awal = periode[0].to_i
    @tahun_akhir = periode[-1].to_i
    @periode = (@tahun_awal..@tahun_akhir)
    @indikator = Indikator.find(params[:id])
    @indikator.target_ikks.build if @indikator.target_ikks.empty?
    @indikator.target_nspks.build if @indikator.target_nspks.empty?
    @indikator.target_lainnyas.build if @indikator.target_lainnyas.empty?
  end

  def update_iku
    @indikator = Indikator.find(params[:id])
    return unless @indikator.update(indikator_params)

    render json: { resText: 'Target disimpan',
                   html_content: html_content({ periode: (2019..2024), indikator: @indikator },
                                              partial: 'laporans/substansi_renstra/iku_tujuan_opd') }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_indikator
    @indikator = Indikator.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def indikator_params
    params.require(:indikator).permit(:indikator, :jenis, :sub_jenis,
                                      :tahun, :kode_opd, :target, :satuan,
                                      :sumber_data,
                                      :rumus_perhitungan,
                                      :keterangan,
                                      target_nspks,
                                      target_ikks,
                                      target_lainnyas,
                                      target_renstras)
  end

  def target_nspks
    { target_nspks_attributes: %i[id target] }
  end

  def target_ikks
    { target_ikks_attributes: %i[id target] }
  end

  def target_lainnyas
    { target_lainnyas_attributes: %i[id target] }
  end

  def target_renstras
    { targets_attributes: %i[id target satuan tahun] }
  end

  def new_indikator_params
    params.permit(:jenis, :sub_jenis, :tahun, :kode_opd)
  end

  def handle_filters
    filter_query = params[:filter_query]
    @tahun = if filter_query == 'tahun'
               params[:tahun]
             else
               cookies[:tahun]
             end
    @indikators = Indikator.includes(:opd).where(tahun: @tahun, sub_jenis: %w[Output Outcome]).limit(20)
  end
end
