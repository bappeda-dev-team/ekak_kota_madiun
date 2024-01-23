class RenstraController < ApplicationController
  before_action :set_renstra
  layout false, only: [:edit_realisasi]

  def index
    # base_data = KakService.new(tahun: 2022, kode_unik_opd: @kode_unik_opd)
    # @program_kegiatans = base_data.program_kegiatans_by_opd
    @periode = params[:periode]
  end

  def admin_renstra; end

  def new
    @nama = params[:nama]
    @kode = params[:kode]
    @jenis = params[:jenis]
    @sub_jenis = params[:sub_jenis]
    @kode_indikator = params[:kode_indikator] || KodeService.new(@kode, @jenis, @sub_jenis).call
    render partial: 'form_renstra_new'
  end

  def create
    indikator_input = params[:indikator]
    keterangan = params[:keterangan]
    param_indikator = indikator_params.to_h
    @indikator = param_indikator[:indikator]
    @indikator.each do |h|
      h[:indikator] = indikator_input
      h[:keterangan] = keterangan
    end
    kode_ind = params[:_kode_indikator]
    indikator_check = Indikator.where(kode_indikator: kode_ind)
    if indikator_check.any?
      kotak = indikator_check.maximum(:kotak) + 1
      @indikator.each do |h|
        h[:kotak] = kotak
      end
    end
    indikator = Indikator.upsert_all(@indikator, returning: %w[indikator tahun target satuan pagu])
    render json: { resText: 'Data disimpan', result: indikator }, status: :accepted if indikator
  end

  def edit
    @nama = params[:nama]
    @kode = params[:kode]
    @kode_opd = params[:kode_opd]
    @satuan = params[:satuan]
    @jenis = params[:jenis]
    @sub_jenis = params[:sub_jenis]
    @id = params[:id]
    @periode = (params[:tahun_awal]..params[:tahun_akhir])
    @program = ProgramKegiatan.find(@id)
    @targets = @program.send("target_#{@sub_jenis.downcase}_renstra")
    @kode_indikator = params[:kode_indikator] || KodeService.new(@kode, @jenis, @sub_jenis).call
    render partial: 'form_renstra'
  end

  def edit_realisasi
    @nama = params[:nama]
    @kode = params[:kode]
    @kode_opd = params[:kode_opd]
    @satuan = params[:satuan]
    @jenis = params[:jenis]
    @sub_jenis = params[:sub_jenis]
    @id = params[:id]
    @periode = (params[:tahun_awal]..params[:tahun_akhir])
    @program = ProgramKegiatan.find(@id)
    @targets = @program.send("target_#{@sub_jenis.downcase}_renstra")
    @kode_indikator = params[:kode_indikator] || KodeService.new(@kode, @jenis, @sub_jenis).call
  end

  def update_programs
    # indikator_input = params[:indikator]
    @periode = (2019..2024)
    program = ProgramKegiatan.find(params[:id])
    keterangan = params[:keterangan]
    param_indikator = indikator_params.to_h
    @indikator = param_indikator[:indikator]
    @indikator.each do |h|
      h[:keterangan] = keterangan
    end
    kode_ind = params[:_kode_indikator]
    indikator_check = Indikator.where(kode_indikator: kode_ind)
    if indikator_check.any?
      versi = indikator_check.maximum(:version) + 1
      @indikator.each do |h|
        h[:version] = versi
      end
    end
    indikator = Indikator.upsert_all(@indikator)

    return unless indikator

    render json: { resText: 'Data disimpan',
                   html_content: html_content({ subgiat: program, no_subgiat: 'xx' },
                                              partial: 'renstra/subkegiatan_renstra.html.erb') }.to_json,
           status: :accepted
  end

  def laporan_renstra
    @kode_opd = cookies[:opd]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @program_kegiatans = @opd.program_renstra
    render partial: 'hasil_filter_renstra'
  end
  helper_method :laporan_renstra

  private

  def set_renstra
    @kode_unik_opd = params[:kode_unik_opd]
    @tahun = params[:tahun]
  end

  def renstra_params
    params.require(:program_kegiatan)
          .permit(:nama_subkegiatan, :tahun, :target_subkegiatan, :indikator_subkegiatan)
  end

  def indikator_params
    params.require(:renstra).permit(indikator: %i[indikator tahun satuan kode jenis sub_jenis target pagu keterangan
                                                  kode_opd kode_indikator realisasi realisasi_pagu])
  end
end
