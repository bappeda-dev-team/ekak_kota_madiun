class IndikatorsController < ApplicationController
  before_action :set_indikator, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

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

    @sasaran_kota = tematiks.sub_tematiks.map(&:pohonable).compact_blank
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
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd
    @lppd_outcome = opd.lppd_outcome.where(tahun: @tahun)
  end

  def lppd_output
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd
    @lppd_output = opd.lppd_output.where(tahun: @tahun)
  end

  def spm_outcome
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd
    @spm_outcome = opd.spm_outcome.where(tahun: @tahun)
  end

  def spm_output
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd
    @spm_output = opd.spm_output.where(tahun: @tahun)
  end

  def sdgs_outcome
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd
    @sdgs_outcome = opd.sdgs_outcome.where(tahun: @tahun)
  end

  def sdgs_output
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd
    @sdgs_output = opd.sdgs_output.where(tahun: @tahun)
  end

  def rb_outcome
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd
    @rb_outcome = opd.rb_outcome.where(tahun: @tahun)
  end

  def rb_output
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = opd.nama_opd
    @rb_output = opd.rb_output.where(tahun: @tahun)
  end

  # GET /indikators or /indikators.json
  def index
    @indikators = Indikator.all
  end

  # GET /indikators/1 or /indikators/1.json
  def show; end

  # GET /indikators/new
  def new
    @indikator = Indikator.new(new_indikator_params)
  end

  # GET /indikators/1/edit
  def edit; end

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

    respond_to do |format|
      format.html { redirect_to indikators_url, notice: "Indikator was successfully destroyed." }
      format.json { head :no_content }
    end
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
                                      :keterangan)
  end

  def new_indikator_params
    params.permit(:jenis, :sub_jenis, :tahun, :kode_opd)
  end
end
