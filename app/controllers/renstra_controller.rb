class RenstraController < ApplicationController
  before_action :set_renstra
  layout false, only: %i[laporan]

  def index
    # goto #laporan in this controller for data
    @periode = params[:periode]
    @jenis_periode = params[:jenis_periode]
  end

  def admin_renstra; end

  def edit_indikator
    # untuk indikator
    @nama = params[:nama]
    @kode = params[:kode]
    @kode_opd = params[:kode_opd]
    @parent = params[:parent]
    @jenis = params[:jenis]
    @sub_jenis = params[:sub_jenis]
    @sub_sub_jenis = params[:sub_sub_jenis]
    @tahun_awal = params[:tahun_awal]
    @tahun_akhir = params[:tahun_akhir]
    @periode = (@tahun_awal..@tahun_akhir)
    @dom_target = "#{@kode}-#{@kode_opd}"
    @kode_indikator = KodeService.new(@kode, @jenis, @sub_jenis).call
    indikator_in_periode_base = Indikator.where(kode_indikator: @kode_indikator,
                                                kode_opd: @kode_opd)
                                         .where("tahun::integer BETWEEN ?::integer AND ?::integer", @tahun_awal, @tahun_akhir)
    indikator_in_periode = if @sub_sub_jenis == 'RPD'
                             indikator_in_periode_base.where(sub_sub_jenis: ['', nil, @sub_sub_jenis])
                           else
                             indikator_in_periode_base.where(sub_sub_jenis: @sub_sub_jenis)
                           end
    @targets = indikator_in_periode.to_h do |ind|
      [ind.tahun, {
        indikator: ind.indikator,
        target: ind.target,
        satuan: ind.satuan,
        pagu: ind.pagu,
        version: ind.version
      }]
    end
    render partial: 'form_renstra'
  end

  def update_indikator
    @tahun_awal = params[:tahun_awal]
    @tahun_akhir = params[:tahun_akhir]
    @kode_opd = params[:kode_opd]
    @nama = params[:nama]
    @kode = params[:kode]
    @parent = params[:parent]
    @jenis = params[:jenis]
    @sub_sub_jenis = params[:sub_sub_jenis]

    periode = (@tahun_awal..@tahun_akhir)
    indikator_attributes = indikator_params[:indikator]
    @indikators = Indikator.create(indikator_attributes)

    set_indikators = @indikators.to_h do |ind|
      [ind.tahun, {
        indikator: ind.indikator,
        target: ind.target,
        satuan: ind.satuan
      }]
    end
    set_pagu = @indikators.to_h do |ind|
      [ind.tahun, ind.pagu.to_i]
    end

    program = {
      jenis: @jenis,
      kode_opd: @kode_opd,
      kode: @kode,
      nama: @nama,
      indikators: set_indikators,
      pagu: set_pagu
    }
    partial = render_to_string(RenstraRowComponent.new(program: program,
                                                       periode: periode,
                                                       cetak: false,
                                                       head: false,
                                                       parent: @parent,
                                                       jenis_periode: @sub_sub_jenis,
                                                       anggaran: set_pagu))
    render json: { resText: 'Data disimpan',
                   html_content: partial }.to_json,
           status: :accepted
  end

  def edit_realisasi
    form_edit_attr
    render partial: 'form_realisasi'
  end

  def laporan
    @kode_opd = cookies[:opd]
    @tahun = cookies[:tahun]
    periode = params[:periode].split('-')
    @tahun_awal = periode[0].to_i
    @tahun_akhir = periode[-1].to_i
    @jenis_periode = params[:jenis_periode]
    renstra = RenstraQueries.new(kode_opd: @kode_opd, tahun_awal: @tahun_awal, tahun_akhir: @tahun_akhir,
                                 jenis_periode: @jenis_periode)
    @nama_opd = renstra.opd.nama_opd
    @program_kegiatans = renstra.program_kegiatan_renstra
    @periode = renstra.periode

    # tujuan sasaran opd
    @opd = renstra.opd
    @user = @opd.eselon_dua_opd
    @sasaran_opds = @user.sasaran_pohon_kinerja_periode(@periode)
    @tujuan_opds = @opd.tujuan_opds.where(tahun_awal: @periode, tahun_akhir: @periode)
  end

  # rubocop: disable Metrics
  def renstra_cetak
    @title = "Renstra"
    @tahun_awal = params[:tahun_awal]
    @tahun_akhir = params[:tahun_akhir]
    @jenis_periode = params[:jenis_periode]
    renstra = RenstraQueries.new(kode_opd: @kode_unik_opd, tahun_awal: @tahun_awal, tahun_akhir: @tahun_akhir,
                                 jenis_periode: @jenis_periode)
    @nama_opd = renstra.opd.nama_opd
    @program_kegiatans = renstra.program_kegiatan_renstra
    @periode = renstra.periode

    # tujuan sasaran opd
    @opd = renstra.opd
    @user = @opd.eselon_dua_opd
    @sasaran_opds = @user.sasaran_pohon_kinerja_periode(@periode)
    @tujuan_opds = @opd.tujuan_opds.where(tahun_awal: @periode, tahun_akhir: @periode)

    # render template: 'renstra/renstra_cetak.html.erb', layout: 'print.html.erb'
    respond_to do |format|
      format.html do
        render template: 'renstra/renstra_cetak.html.erb', layout: 'print.html.erb'
      end
      format.xlsx do
        render filename: "renstra_#{@nama_opd}_#{@tahun_awal}_#{@tahun_akhir}"
      end
    end
  end

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
    params.require(:renstra).permit(indikator: %i[indikator tahun satuan
                                                  kode jenis sub_jenis sub_sub_jenis
                                                  target pagu keterangan
                                                  kode_opd kode_indikator
                                                  realisasi realisasi_pagu version])
  end
end
