class RenjaController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[rankir_renja rankir_renja_1 penetapan_renja]
  before_action :set_renja

  def index
    # base_data = KakService.new(tahun: 2022, kode_unik_opd: @kode_unik_opd)
    # @program_kegiatans = base_data.program_kegiatans_by_opd
  end

  def ranwal; end

  def ranwal_cetak
    @title = "Rawnal Renja"
    @tahun = params[:tahun]
    @opd = Opd.find_by(kode_unik_opd: params[:kode_opd])
    @nama_opd = @opd.nama_opd
    # @program_kegiatans = @opd.susunan_renja
    # if OPD_TABLE.key?(@nama_opd.to_sym)
    #   @program_kegiatans = ProgramKegiatan.includes(:opd)
    #                                       .where(id_sub_unit: KODE_OPD_BAGIAN[@nama_opd.to_sym], tahun: @tahun)
    #                                       .uniq(&:kode_program).sort_by(&:kode_program)
    #   @kode_opd = KODE_OPD_BAGIAN[@nama_opd.to_sym]
    # end
    program_renstra = @opd.program_renstra
    @tahun_awal = @tahun.to_i
    @tahun_akhir = @tahun.to_i
    @periode = (@tahun_awal..@tahun_akhir)
    @program_kegiatans = program_renstra.group_by { |prg| [prg.kode_bidang_urusan, prg.nama_bidang_urusan] }
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "ranwal_renja_#{@nama_opd}_tahun_#{@tahun}",
               dispotition: 'attachment',
               page_size: 'Legal',
               layout: 'pdf.html.erb',
               template: 'renja/ranwal_cetak.html.erb',
               show_as_html: params.key?('debug')
      end
      format.xlsx do
        render filename: "ranwal_renja_#{@nama_opd}_tahun_#{@tahun}"
      end
    end
  end

  def rankir_1; end
  def rankir; end

  def rankir_renja_1
    @kode_opd = params[:kode_opd]
    @tahun_asli = params[:tahun]
    @tahun = @tahun_asli.gsub("_perubahan", "")
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @program_kegiatans = @opd.program_renstra
    render partial: 'rankir_renja_1'
  end

  def rankir_renja
    @kode_opd = params[:kode_opd]
    @tahun_asli = params[:tahun]
    @tahun = @tahun_asli.gsub("_perubahan", "")
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @program_kegiatans = @opd.program_renstra
    render partial: 'rankir_renja'
  end

  def penetapan; end

  def penetapan_renja
    @kode_opd = params[:kode_opd]
    @tahun = params[:tahun]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @program_kegiatans = @opd.program_renstra
    render partial: 'penetapan_renja'
  end

  def perubahan; end

  def perubahan_renja
    @kode_opd = params[:kode_opd]
    @tahun = params[:tahun]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @program_kegiatans = @opd.program_renstra
    render partial: 'perubahan_renja'
  end

  def new
    @nama = params[:nama]
    @kode = params[:kode]
    @jenis = params[:jenis]
    @sub_jenis = params[:sub_jenis]
    @kode_indikator = params[:kode_indikator] || KodeService.new(@kode, @jenis, @sub_jenis).call
    render partial: "form_renstra_new"
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
    render json: { resText: "Data disimpan", result: indikator }, status: :accepted if indikator
  end

  def edit_rankir
    @nama = params[:nama]
    @kode = params[:kode]
    @kode_opd = params[:kode_opd]
    @satuan = params[:satuan]
    @jenis = params[:jenis]
    @sub_jenis = params[:sub_jenis]
    @id = params[:id]
    @program = ProgramKegiatan.find(@id)
    @tahun = params[:tahun]
    @pagu = params[:pagu]
    @targets = @program.send("target_#{@sub_jenis.downcase}_renstra")
    @keterangan = @targets.empty? ? "" : @targets[@tahun][:keterangan]
    @kode_indikator = params[:kode_indikator] || KodeService.new(@kode, @jenis, @sub_jenis).call
    render partial: "form_renja"
  end

  def update_rankir
    # indikator_input = params[:indikator]
    keterangan = params[:keterangan]
    param_indikator = indikator_params.to_h
    @indikator = param_indikator[:indikator]
    @indikator.each do |h|
      # h[:indikator] = indikator_input
      h[:keterangan] = keterangan
    end
    kode_ind = params[:_kode_indikator]
    indikator_check = Indikator.where(kode_indikator: kode_ind, jenis: "Rankir_Renja")
    if indikator_check.any?
      versi = indikator_check.maximum(:version) + 1
      @indikator.each do |h|
        h[:version] = versi
      end
    end
    indikator = Indikator.upsert_all(@indikator, returning: %w[indikator tahun target satuan pagu])
    render json: { resText: "Data disimpan", result: indikator }, status: :accepted if indikator
  end

  def set_renja
    @kode_unik_opd = params[:kode_unik_opd]
    @tahun = params[:tahun]
  end

  private

  def renstra_params
    params.require(:program_kegiatan)
          .permit(:nama_subkegiatan, :tahun, :target_subkegiatan, :indikator_subkegiatan)
  end

  def indikator_params
    params.require(:renstra).permit(indikator: %i[indikator tahun satuan kode jenis sub_jenis target pagu keterangan
                                                  kode_opd kode_indikator])
  end
end
