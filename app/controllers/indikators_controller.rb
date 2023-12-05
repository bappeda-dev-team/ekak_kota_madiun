class IndikatorsController < ApplicationController
  before_action :set_indikator, only: %i[show edit update destroy]

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
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @program_kegiatans = @opd.program_renstra

    render layout: false
  end

  def sasaran_renja_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]

    pohon_kinerja = PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd)
    @opd = pohon_kinerja.opd
    @nama_opd = @opd.nama_opd
    @sasarans_opd = pohon_kinerja.strategi_opd.map(&:sasarans).flatten.compact_blank
  end

  def program_renja_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]

    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @programs = @opd.program_renstra
  end

  def kegiatan_renja_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]

    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @kegiatans = @opd.kegiatans_renstra
  end

  def subkegiatan_renja_opd
    @tahun = cookies[:tahun]
    @kode_opd = cookies[:opd]

    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @subkegiatans = @opd.subkegiatans_renstra
  end

  # GET /indikators or /indikators.json
  def index
    @indikators = Indikator.all
  end

  # GET /indikators/1 or /indikators/1.json
  def show; end

  # GET /indikators/new
  def new
    @indikator = Indikator.new
  end

  # GET /indikators/1/edit
  def edit; end

  # POST /indikators or /indikators.json
  def create
    @indikator = Indikator.new(indikator_params)

    respond_to do |format|
      if @indikator.save
        format.html { redirect_to indikator_url(@indikator), notice: "Indikator was successfully created." }
        format.json { render :show, status: :created, location: @indikator }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @indikator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /indikators/1 or /indikators/1.json
  def update
    respond_to do |format|
      if @indikator.update(indikator_params)
        format.html { redirect_to indikator_url(@indikator), notice: "Indikator was successfully updated." }
        format.json { render :show, status: :ok, location: @indikator }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @indikator.errors, status: :unprocessable_entity }
      end
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
    params.fetch(:indikator, {})
  end
end
