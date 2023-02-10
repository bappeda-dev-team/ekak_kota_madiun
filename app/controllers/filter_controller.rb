class FilterController < ApplicationController
  include Renstra::OpdKhusus

  before_action :filter_params, except: %i[filter_tematiks]
  before_action :nama_opd, only: %i[filter_gender filter_struktur]

  def filter_sasaran
    opd = Opd.find_by(kode_opd: @kode_opd).nama_opd
    @nama_opd ||= opd || "-"
    @sasarans = Sasaran.includes([user: :opd]).where(opds: { kode_opd: @kode_opd }).where(nip_asn: params[:nip_asn])
    if OPD_TABLE.key?(opd.to_sym)
      @sasarans = Sasaran.includes([user: :opd]).where(opds: { kode_unik_opd: KODE_OPD_TABLE[opd.to_sym] }).where(nip_asn: params[:nip_asn])
      @sasarans = @sasarans.where(user: { nama_bidang: OPD_TABLE[opd.to_sym] })
    end
    respond_to do |format|
      format.js { render "sasarans/sasaran_filter" }
    end
  end

  def filter_user # FIXME: jika tidak ada bidang pada opd table, user tidak akan tampil
    opd = Opd.find_by(kode_unik_opd: @kode_opd).nama_opd
    @users = User.includes([:opd]).where(opds: { kode_unik_opd: @kode_opd })
    if OPD_TABLE.key?(opd.to_sym)
      @users = User.includes([:opd]).where(opds: { kode_unik_opd: KODE_OPD_TABLE[opd.to_sym] })
                   .where(nama_bidang: OPD_TABLE[opd.to_sym])
    end
    @filter_file = "hasil_filter" if params[:filter_file].empty?
    respond_to do |format|
      format.js { render "users/user_filter" }
    end
  end

  # filter subkegiatan
  def filter_subkegiatan
    opd = Opd.find_by(kode_unik_opd: @kode_opd).nama_opd
    @tahun = @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @programKegiatans = ProgramKegiatan.order(:id).includes(%i[opd])
                                       .where(opds: { kode_unik_opd: @kode_opd })
                                       .where(tahun: @tahun)
    if OPD_TABLE.key?(opd.to_sym)
      @programKegiatans = ProgramKegiatan.order(:id).includes(%i[opd])
                                         .where(id_sub_unit: KODE_OPD_BAGIAN[opd.to_sym])
                                         .where(tahun: @tahun)
    end
    render partial: 'program_kegiatans/hasil_filter_subkegiatan'
  end

  def filter_program
    @tahun = @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
    opd = Opd.find_by(kode_unik_opd: @kode_opd).nama_opd

    @program_kegiatans = ProgramKegiatan.includes(:opd)
                                        .select("DISTINCT ON(program_kegiatans.kode_program) program_kegiatans.*")
                                        .where(opds: { kode_unik_opd: @kode_opd })
                                        .where(tahun: @tahun)
    if OPD_TABLE.key?(opd.to_sym)
      @program_kegiatans = ProgramKegiatan.includes(:opd)
                                          .select("DISTINCT ON(program_kegiatans.kode_program) program_kegiatans.*")
                                          .where(id_sub_unit: KODE_OPD_BAGIAN[opd.to_sym])
                                          .where(tahun: @tahun)
    end
    render partial: 'program_kegiatans/hasil_filter_program'
  end

  def filter_kegiatan
    @tahun = @tahun.match(/murni/) ? @tahun[/[^_]\d*/, 0] : @tahun
    opd = Opd.find_by(kode_unik_opd: @kode_opd).nama_opd
    @programKegiatans = ProgramKegiatan.includes(:opd)
                                       .select("DISTINCT ON(program_kegiatans.kode_giat) program_kegiatans.*")
                                       .where(opds: { kode_unik_opd: @kode_opd })
                                       .where(tahun: @tahun)
    if OPD_TABLE.key?(opd.to_sym)
      @programKegiatans = ProgramKegiatan.includes(:opd)
                                         .select("DISTINCT ON(program_kegiatans.kode_giat) program_kegiatans.*")
                                         .where(id_sub_unit: KODE_OPD_BAGIAN[opd.to_sym])
                                         .where(tahun: @tahun)
    end
    render partial: 'program_kegiatans/hasil_filter_kegiatan'
  end

  def filter_kak_dashboard
    kak = KakService.new(kode_unik_opd: @kode_opd, tahun: @tahun)
    @program_kegiatans = kak.laporan_rencana_kinerja
    @total_pagu = kak.total_pagu
    # if OPD_TABLE.key?(opd.nama_opd.to_sym)
    #   @program_kegiatans = ProgramKegiatan.joins(:opd).where(opds: { kode_opd: KODE_OPD_TABLE[opd.nama_opd.to_sym] })
    #   @program_kegiatans = @program_kegiatans.where(nama_bidang: OPD_TABLE[opd.nama_opd.to_sym])
    # end
    @filter_file = "hasil_filter_dashboard"
    # @message = @program_kegiatans ? "Berhasil" : "Ada yang salah"
    # @icon = @program_kegiatans ? "success" : "error"
    render "kaks/kak_filter_dashboard"
  end

  def filter_kak
    kak = KakService.new(kode_unik_opd: @kode_opd, tahun: @tahun)
    @program_kegiatans = kak.sasarans_by_user
    @total_pagu = kak.total_pagu
    @jumlah_subkegiatan = kak.laporan_rencana_kinerja.size
    @total_sasaran_aktif = kak.total_sasaran_aktif
    @total_usulans = kak.total_usulan_musrenbang
    # if OPD_TABLE.key?(opd.to_sym)
    #   @users = User.includes([:opd]).where(opds: { kode_unik_opd: KODE_OPD_TABLE[opd.to_sym] }).asn_aktif
    #   @users = @users.where(nama_bidang: OPD_TABLE[opd.to_sym])
    # end
    @opd = Opd.find_by(kode_unik_opd: @kode_opd).id
    @tahun = kak.tahun
    @filter_file = "hasil_filter" if params[:filter_file].empty?
    render "kaks/kak_filter"
  end

  def filter_rab
    kak = KakService.new(kode_unik_opd: @kode_opd, tahun: @tahun)
    @program_kegiatans = kak.sasarans_by_user
    # if OPD_TABLE.key?(opd.to_sym)
    #   @users = User.includes([:opd]).where(opds: { kode_unik_opd: KODE_OPD_TABLE[opd.to_sym] }).asn_aktif
    #   @users = @users.where(nama_bidang: OPD_TABLE[opd.to_sym])
    # end
    @filter_file = params[:filter_file].empty? ? "hasil_filter_rab" : params[:filter_file]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd).id
    render "program_kegiatans/rab_filter"
  end

  def filter_rasionalisasi
    opd = Opd.find_by(kode_unik_opd: @kode_opd).nama_opd
    @program_kegiatans = ProgramKegiatan.includes(%i[opd])
                                        .joins(:sasarans)
                                        .where(opds: { kode_unik_opd: @kode_opd })
    if OPD_TABLE.key?(opd.to_sym)
      @program_kegiatans = ProgramKegiatan.includes(%i[opd])
                                          .joins(:sasarans)
                                          .where(id_sub_unit: KODE_OPD_BAGIAN[opd.to_sym])
    end
    respond_to do |format|
      @render_file = "rasionalisasi/hasil_filter_rasionalisasi"
      format.js { render "rasionalisasi/rasionalisasi_filter" }
    end
  end

  def filter_gender
    opd = Opd.find_by(kode_unik_opd: @kode_opd).nama_opd
    @program_kegiatans = ProgramKegiatan.includes(%i[opd sasarans])
                                        .joins(:sasarans)
                                        .where(opds: { kode_unik_opd: @kode_opd })
    if OPD_TABLE.key?(opd.to_sym)
      @program_kegiatans = ProgramKegiatan.includes(%i[opd])
                                          .joins(:sasarans)
                                          .where(id_sub_unit: KODE_OPD_BAGIAN[opd.to_sym])
    end
    respond_to do |format|
      @render_file = "genders/hasil_filter_gender"
      format.js { render "genders/gender_filter" }
    end
  end

  def filter_opd
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @filter_file = params[:filter_file].empty? ? "hasil_filter_opd" : params[:filter_file]
    respond_to do |format|
      format.js { render "opds/opd_filter" }
    end
  end

  def tujuan_opd
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @tujuan_opds = @opd.tujuan_opds
    render partial: 'opds/tujuan_opd'
  end

  def sasaran_opd
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @sasaran_opds = @opd.sasaran_opds
    render partial: 'opds/sasaran_opd'
  end

  def filter_usulan
    @type = params[:jenis].capitalize
    @type_alsi = @type.capitalize
    if @type == "Inisiatif"
      @type = "Inovasi"
      @type_alsi = "Inisiatif Walikota"
    end
    if @kode_opd == "all"
      @program_kegiatans = ProgramKegiatan.includes(%i[opd usulans])
                                          .where(usulans: { usulanable_type: @type })
                                          .select { |p| p.sasarans.exists? }
      @nama_opd = "Semua OPD"
    else
      @program_kegiatans = ProgramKegiatan.includes(%i[opd usulans]).where(opds: { kode_unik_opd: @kode_opd })
                                          .where(usulans: { usulanable_type: @type })
                                          .select { |p| p.sasarans.exists? }
      @nama_opd = nama_opd
    end
    respond_to do |format|
      format.js { render "usulans/usulan_filter" }
    end
  end

  def filter_user_sasarans
    opd = Opd.find_by(kode_unik_opd: @kode_opd).nama_opd
    @users = User.includes([:opd]).where(opds: { kode_unik_opd: @kode_opd }).asn_aktif
    if OPD_TABLE.key?(opd.to_sym)
      @users = User.includes([:opd]).where(opds: { kode_unik_opd: KODE_OPD_TABLE[opd.to_sym] }).asn_aktif
      @users = @users.where(nama_bidang: OPD_TABLE[opd.to_sym])
    end
    nama_opd
    @filter_file = params[:filter_file].empty? ? "hasil_filter" : params[:filter_file]
    respond_to do |format|
      format.js { render "sasarans/user_sasarans" }
    end
  end

  def filter_tematiks
    @kode_tematik = params[:kode_tematik]
    @tahun = params[:tahun]
    @nama_tematik = SubkegiatanTematik.find_by(kode_tematik: @kode_tematik).nama_tematik
    @tematiks = Sasaran.sasaran_tematik(@kode_tematik)
    respond_to do |format|
      format.js { render "subkegiatan_tematiks/tematik_filter" }
    end
  end

  def filter_tematiks_apbd
    @kode_tematik = params[:kode_tematik]
    @tahun = params[:tahun]
    @nama_tematik = SubkegiatanTematik.find_by(kode_tematik: @kode_tematik).nama_tematik
    @tematiks = Sasaran.sasaran_tematik(@kode_tematik)
    respond_to do |format|
      format.js { render "subkegiatan_tematiks/tematik_filter_apbd" }
    end
  end

  def filter_struktur
    opd = Opd.find_by(kode_unik_opd: @kode_opd).nama_opd
    @strukturs = Opd.find_by(kode_unik_opd: @kode_opd).kepala
    @strukturs = Opd.find_by(kode_unik_opd: KODE_OPD_TABLE[opd.to_sym]).kepala if OPD_TABLE.key?(opd.to_sym)
    # @filter_file = params[:filter_file]
    @filter_file = "hasil_filter_struktur"
    respond_to do |format|
      format.js { render "users/strukturs" }
    end
  end

  def filter_rekap_jumlah
    if @kode_opd == "all"
      @rekaps = Rekap.new(kode_unik_opd: @kode_opd).all_rekap
      @nama_opd = "Kota Madiun"
    else
      @rekaps = Rekap.new(kode_unik_opd: @kode_opd).jumlah_rekap
      @nama_opd = nama_opd
    end
    @filter_file = params[:filter_file]
    respond_to do |format|
      format.js { render "rekaps/rekap_jumlah" }
    end
  end

  def daftar_resiko
    @daftar_resiko = DaftarResiko.new(kode_unik_opd: @kode_opd, tahun: @tahun)
    @tahun_bener = @daftar_resiko.tahun
    @program_kegiatans = @daftar_resiko.daftar_resiko_opd
    @opd = Opd.find_by(kode_unik_opd: @kode_opd).id
    #    if OPD_TABLE.key?(@opd.nama_opd.to_sym)
    #      @program_kegiatans = ProgramKegiatan.joins(:opd).where(opds: { kode_opd: KODE_OPD_TABLE[@opd.nama_opd.to_sym] }).with_sasarans(@tahun_sasaran)
    #      @program_kegiatans = @program_kegiatans.where(nama_bidang: OPD_TABLE[@opd.nama_opd.to_sym]) # idk about bidang thing
    #    end
    @id_target = "daftar_resiko"
    @filter_file = params[:filter_file].empty? ? "hasil_filter" : params[:filter_file]
    respond_to do |format|
      format.js { render "result_renderer" }
    end
  end

  def isu_strategis_permasalahan
    @program_kegiatans = KakService.new(kode_unik_opd: @kode_opd, tahun: @tahun).isu_strategis
    render partial: "filter/hasil_filter_isu"
  end

  def laporan_renstra
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @program_kegiatans = @opd.program_renstra
    if OPD_TABLE.key?(@nama_opd.to_sym)
      @program_kegiatans = ProgramKegiatan.includes(:opd)
                                          .where(id_sub_unit: KODE_OPD_BAGIAN[@nama_opd.to_sym])
                                          .uniq(&:kode_program).sort_by(&:kode_program)
      @kode_opd = KODE_OPD_BAGIAN[@nama_opd.to_sym]
    end
    render partial: 'hasil_filter_renstra'
  end

  def ranwal_renja
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @nama_opd = @opd.nama_opd
    @program_kegiatans = @opd.program_kegiatans
    if OPD_TABLE.key?(@nama_opd.to_sym)
      @program_kegiatans = ProgramKegiatan.includes(:opd)
                                          .where(id_sub_unit: KODE_OPD_BAGIAN[@nama_opd.to_sym])
                                          .uniq(&:kode_program).sort_by(&:kode_program)
      @kode_opd = KODE_OPD_BAGIAN[@nama_opd.to_sym]
    end
    renja = Renja.new(kode: @kode_opd, tahun: params[:tahun], jenis: '-', tipe: '-')
    @ranwal_renja = renja.ranwal(kode_unik_opd: @kode_opd, tahun: params[:tahun])
    render 'renja/_ranwal_renja_filter'
  end

  # filter tahun yang diaktifkan, dibawah logo E-KAK
  def tahun_sasaran
    @tahun_sasaran = params[:tahun_sasaran]
    @tahun_sasaran = @tahun_sasaran.match(/murni/) ? @tahun_sasaran[/[^_]\d*/, 0] : @tahun_sasaran
    cookies[:tahun_sasaran] = @tahun_sasaran
    render 'shared/_notifier_v2',
           locals: { message: "Tahun Dipilih: #{@tahun_sasaran}", status_icon: 'success', form_name: 'non-exists' }
  end

  def renstra_master
    opd = Opd.find_by(kode_unik_opd: @kode_opd)
    @renstras = Renstra.where(kode_skpd: @kode_opd)
    @filter_file = params[:filter_file]
    @id_opd = opd.id_opd_skp
    @nama_opd = nama_opd
    render partial: 'filter_admin_renstra'
  end

  def crosscutting_kota
    if @kode_opd == "all"
      @sasaran_kota = SasaranKotum.all
      @nama_opd = "Kota Madiun"
    end
    @filter_file = params[:filter_file]
    render partial: 'filter_crosscutting_kota'
  end

  private

  def filter_params
    @kode_opd = params[:kode_opd]
    @tahun = params[:tahun]
    @bulan = params[:bulan]
  end

  def nama_opd
    @nama_opd ||= Opd.find_by(kode_unik_opd: @kode_opd).nama_opd || "-"
  end

  def bidang_checker(models)
    opd = Opd.find_by(kode_unik_opd: @kode_opd).nama_opd
    @results = models.includes([:opd]).where(opds: { kode_unik_opd: @kode_opd })
    if OPD_TABLE.key?(opd.to_sym)
      @results = models.includes([:opd]).where(opds: { kode_unik_opd: KODE_OPD_TABLE[opd.to_sym] })
      @results = @results.where(nama_bidang: OPD_TABLE[opd.to_sym])
    end
  end
end
