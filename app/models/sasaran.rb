# == Schema Information
#
# Table name: sasarans
#
#  id                     :bigint           not null, primary key
#  anggaran               :integer
#  id_rencana             :string
#  indikator_kinerja      :string
#  is_perintah_walikota   :boolean          default(FALSE)
#  jenis_layanan          :string
#  keterangan             :string
#  kualitas               :integer
#  metadata               :jsonb
#  nip_asn                :string
#  nip_asn_sebelumnya     :string
#  penerima_manfaat       :string
#  sasaran_atasan         :string
#  sasaran_kinerja        :string
#  sasaran_kota           :string
#  sasaran_milik          :string
#  sasaran_opd            :string
#  satuan                 :string
#  status                 :enum             default("draft")
#  sumber_dana            :string
#  tahun                  :string
#  target                 :integer
#  type                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  opd_id                 :bigint
#  program_kegiatan_id    :bigint
#  sasaran_atasan_id      :string
#  strategi_id            :string
#  subkegiatan_tematik_id :bigint
#
# Indexes
#
#  index_sasarans_on_id_rencana  (id_rencana) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (nip_asn => users.nik)
#  fk_rails_...  (subkegiatan_tematik_id => subkegiatan_tematiks.id)
#
class Sasaran < ApplicationRecord
  default_scope { order(:id) }
  # belongs_to :user
  belongs_to :user, foreign_key: 'nip_asn', primary_key: 'nik', optional: true
  has_one :opd, through: :user
  belongs_to :program_kegiatan, optional: true
  has_many :tematik_sasarans, dependent: :destroy
  has_many :subkegiatan_tematiks, through: :tematik_sasarans
  # belongs_to :sumber_dana, foreign_key: 'sumber_dana', primary_key: 'kode_sumber_dana', optional: true

  has_many :rencana_aksi_opds
  has_many :usulans, dependent: :destroy
  has_many :dasar_hukums, primary_key: 'id_rencana', class_name: 'DasarHukum',
                          dependent: :destroy
  has_many :musrenbangs, dependent: :nullify
  has_many :pokpirs, dependent: :nullify
  has_many :mandatoris, dependent: :nullify
  has_many :inovasis, dependent: :nullify
  has_many :indikator_sasarans, primary_key: 'id_rencana', dependent: :destroy
  has_many :tahapans, lambda {
    where.not(id_rencana_aksi: [nil, ''])
  }, foreign_key: 'id_rencana', primary_key: 'id_rencana', dependent: :nullify, inverse_of: :sasaran
  has_many :anggarans, through: :tahapans
  has_one :rincian, dependent: :destroy
  has_many :permasalahans, dependent: :destroy
  has_many :latar_belakangs, dependent: :destroy
  has_many :genders
  has_many :reviews, -> { where(reviewable_type: 'Sasaran') }, foreign_key: :reviewable_id, primary_key: :id
  belongs_to :strategi, -> { where.not(role: 'deleted') }, optional: true
  # has_one :strategi
  # has_many :manual_iks, through: :indikator_sasarans

  accepts_nested_attributes_for :rincian, update_only: true
  accepts_nested_attributes_for :tahapans
  accepts_nested_attributes_for :permasalahans
  accepts_nested_attributes_for :indikator_sasarans, reject_if: :all_blank, allow_destroy: true
  # TODO: ganti kualitas dengan aspek ( multiple choice )
  # validation
  validates :sasaran_kinerja, presence: true
  # validates :indikator_kinerja, presence: true
  # validates :target, presence: true
  # validates :satuan, presence: true

  # default_scope { order(created_at: :asc) }
  scope :hangus, -> { left_outer_joins(:usulans).where(usulans: { sasaran_id: nil }).where(program_kegiatan: nil) }
  scope :total_hangus, -> { hangus.count }
  scope :belum_ada_sub, lambda {
    left_outer_joins(:usulans)
      .where.not(usulans: { sasaran_id: nil })
      .where(program_kegiatan: nil)
  }
  scope :total_belum_lengkap, -> { belum_ada_sub.count }
  scope :sudah_lengkap, lambda {
    includes(:usulans, :program_kegiatan).where.not(usulans: { sasaran_id: nil }).where.not(program_kegiatan: nil)
  }
  scope :total_sudah_lengkap, -> { sudah_lengkap.count }
  scope :digunakan, -> { where(status: 'disetujui') }
  scope :total_digunakan, -> { where(status: 'disetujui').count }
  scope :dilaporan, -> { where(status: %w[pengajuan disetujui ditolak]) }
  scope :sasaran_tematik, lambda { |tematik|
    includes(:subkegiatan_tematiks).where(subkegiatan_tematiks: { kode_tematik: tematik })
  }
  scope :kurang_lengkap, -> { select { |s| s.usulans.exists? && s.belum_ada_sub? }.size }
  scope :hijau, -> { select(&:lengkap?).size }
  scope :biru, -> { select(&:selesai?).reject(&:lengkap?).size }
  scope :dengan_sub_kegiatan, -> { joins(:program_kegiatan) }
  scope :dengan_tahapan, -> { joins(:tahapans).where.not(tahapans: { id_rencana: nil }) }
  scope :dengan_rincian, -> { joins(:rincian).includes(:tahapans).where.not(tahapans: { id_rencana: nil }) }
  scope :belum_ada_genders, -> { where.missing(:genders) }
  scope :dengan_strategi, -> { select { |s| s.strategi.present? } }
  scope :dengan_manual_ik, -> { select { |s| s.indikator_sasarans.any?(&:manual_ik) } }
  scope :tanpa_nip, -> { where(nip_asn: [nil, '']) }
  scope :dengan_nip, -> { where.not(nip_asn: [nil, '']) }

  scope :lengkap_strategi_tahun, lambda { |tahun|
    includes(%i[strategi usulans program_kegiatan indikator_sasarans])
      .where(tahun: tahun)
      .select { |s| s.strategi.present? }
  }

  SUMBERS = { dana_transfer: 'Dana Transfer', dak: 'DAK', dbhcht: 'DBHCHT', bk_provinsi: 'BK Provinsi',
              blud: 'BLUD' }.freeze

  HASIL_OUTPUT = ['Bukan Produk Hukum', 'Raperda', 'Raperwal',
                  'Rancang Surat Keputusan'].freeze

  enum status: { draft: 'draft', pengajuan: 'pengajuan', disetujui: 'disetujui', ditolak: 'ditolak' }
  store_accessor :metadata, :hasil_output, :nama_output, :processed_at, :deleted_at, :deleted_by, :keterangan_hapus,
                 :clone_tahun_asal, :clone_oleh, :clone_asli, :id_rencana_sebelum,
                 :inovasi_sasaran, :hasil_inovasi, :jenis_inovasi, :gambaran_nilai_kebaruan,
                 :inovasi_lolos,
                 :status_dampak_resiko, :komentar_dampak_resiko, :verifikator_dampak_resiko,
                 :judul_rincian_tugas, :status_rincian_tugas

  # untuk user manrisk
  attr_accessor :butuh_verifikasi

  # DANGER, maybe broke something, uncomment this
  # def respond_to_missing?(_method, *_args)
  #   0
  # end
  def to_s
    sasaran_kinerja
  end

  def self.cari_nip_asn(nip_asn)
    where("nip_asn ILIKE ?", "%#{nip_asn}%")
      .or(cari_nip_asn_sebelumnya(nip_asn))
      .dengan_strategi
  end

  def self.cari_nip_asn_sebelumnya(nip_asn)
    where("nip_asn_sebelumnya ILIKE ?", "%#{nip_asn}%")
  end

  def aksi_bulan_kosong?
    tahapans.map { |t| t.aksis.map(&:id_aksi_bulan) }.flatten.include?(nil)
  end

  def gambaran_umum_indikator_kosong?
    latar_belakangs.map(&:id_indikator_sasaran).include?(nil)
  end

  def tahun_clone_preparer
    tahun.to_s.split('_').first
  end

  def tahun_tanpa_perubahan
    tahun.gsub('_perubahan', '')
  end

  def program_nil?
    program_kegiatan.nil?
  end

  # method yang ada map nya memang sengaja begitu, karena dibuat collection dan di loop untuk footer bulan
  def target_bulan
    tahapans.map { |t| t.aksis.group(:bulan).sum(:target) }
  end

  def realisasi_bulan
    tahapans.map { |t| t.aksis.group(:bulan).sum(:realisasi) }
  end

  def total_target_aksi_bulan
    tahapans.map { |t| t.aksis.group(:bulan).sum(:target) }.inject do |bln, val|
      bln.merge(val) do |_k, old_v, new_v|
        old_v + new_v
      end
    end
  end

  def total_realisasi_aksi_bulan
    tahapans.map { |t| t.aksis.uniq(:bulan).group(:bulan).sum(:realisasi) }.inject do |bln, val|
      bln.merge(val) do |_k, old_v, new_v|
        old_v + new_v
      end
    end
  end

  def waktu_total
    tahapans.map { |t| t.aksis.group(:bulan).where('target > 0').count(:target) }.inject(:merge).count
  rescue NoMethodError
    '-'
  end

  def progress_total
    jumlah_target = tahapans.sum :jumlah_target
    jumlah_realisasi = tahapans.sum :jumlah_realisasi
    begin
      ((jumlah_realisasi / jumlah_target.to_f) * 100)
    rescue StandardError
      0
    end
  end

  def total_anggaran
    tahapans.includes([:anggarans]).map { |t| t.anggarans.compact.sum(&:jumlah) }.inject(:+).to_d
  rescue TypeError
    '-'
  end

  def total_anggaran_rankir_1
    tahapans.includes([:anggarans]).map { |t| t.anggarans.compact.sum(&:anggaran_rankir_1) }.inject(:+).to_d
  rescue TypeError
    '-'
  end

  def total_anggaran_dengan_komentar
    tahapans.map { |t| t.anggarans.where.missing(:comments).compact.sum(&:jumlah) }.inject(:+).to_d
  rescue TypeError
    '-'
  end

  def total_anggaran_penetapan
    tahapans.includes([:anggarans]).map(&:anggaran_tahapan_penetapan).inject(:+).to_d
  rescue TypeError
    '-'
  end

  def anggaran_sub
    program_kegiatan&.pagu_tanpa_lengkap(tahun) || 0
  end

  def jumlah_target
    tahapans.sum(:jumlah_target).nonzero? || 0
  end

  def cek_jumlah_target(aksi_id)
    tahapans.flat_map { |t| t.aksis.where.not(id: aksi_id).pluck(:target) }
            .sum
  end

  def target_sesuai?
    jumlah_target.to_i == 100
  rescue NoMethodError
    '-'
  end

  def my_usulan
    usulans.map(&:usulanable)
  end

  def sync_total_renaksi
    tahapans.each(&:sync_total_renaksi)
  end

  def hangus?
    usulans.empty?
  end

  def belum_ada_sub?
    program_kegiatan.nil?
  end

  def selesai?
    # !(hangus? || belum_ada_sub?)
    usulans.exists? && program_kegiatan.present?
  end

  def subkegiatan?
    program_kegiatan.present? && program_kegiatan&.valid_kode_opd_subkegiatan
  end

  def lengkap?
    selesai? && rincian? && permasalahan? && dasar_hukum? && gambaran_umum? && tematik?
  end

  def rincian?
    rincian.present? && penerima_manfaat.present?
  end

  def permasalahan?
    permasalahans.exists?
  end

  def dasar_hukum?
    dasar_hukums.exists?
  end

  def gambaran_umum?
    latar_belakangs.exists?
  end

  def tematik?
    subkegiatan_tematiks.exists?
  end

  def biru?
    selesai? && subkegiatan_tematiks.empty?
  end

  def biru_helper
    petunjuk_status.except(:usulan_dan_sub).values.any?(false)
  end

  # TODO: try this method to simplify in user
  def status_sasaran
    if siap_ditarik?
      'siap_ditarik'
    elsif hangus?
      # 'hangus' # merah
      'belum_selesai'
    elsif belum_ada_sub?
      'blm_lengkap' # kuning
    elsif biru_helper
      'krg_lengkap' # biru
    elsif lengkap?
      'digunakan' # hijau
    end
  end

  def petunjuk_status
    usulan_dan_sub = selesai?
    rincian_sasaran = rincian.present? && penerima_manfaat.present?
    permasalahan_rencan = permasalahans.any?
    dasar_hukum = dasar_hukums.any?
    gambaran_umum = latar_belakangs.any?
    tematik_saaran = subkegiatan_tematiks.any?
    manual_ik = manual_ik?
    tahapan = tahapan?
    {
      usulan_dan_sub: usulan_dan_sub,
      rincian_sasaran: rincian_sasaran,
      permasalahan: permasalahan_rencan,
      dasar_hukum: dasar_hukum,
      gambaran_umum: gambaran_umum,
      tematik: tematik_saaran,
      manual_ik: manual_ik,
      tahapan: tahapan
    }
  end

  def petunjuk_tarik
    manual_ik = manual_ik?
    tahapan = tahapan?
    {
      manual_ik: manual_ik,
      tahapan: tahapan
    }
  end

  def status_badge(petunjuk)
    petunjuk.reject { |_key, val| val }
  end

  def add_tematik(sasaran:, tematik:)
    tematik_exists = TematikSasaran.where(sasaran_id: sasaran, subkegiatan_tematik_id: tematik)
    if tematik_exists.exists?
      tematik_exists.update(sasaran_id: sasaran, subkegiatan_tematik_id: tematik)
    else
      TematikSasaran.create(sasaran_id: sasaran, subkegiatan_tematik_id: tematik)
    end
  end

  def rekin_atasan
    return nil if sasaran_atasan_id.nil?

    Sasaran.find_by(id_rencana: sasaran_atasan_id)
  end

  def indikator_rekin_atasan
    return nil if sasaran_atasan_id.nil?

    rekin_atasan.indikator_sasarans
  end

  def program_kabid
    sasaran_kasi.map { |s| s.program_kegiatan&.nama_program || '-' }.uniq
  end

  def sasaran_kasi
    Sasaran.where(sasaran_atasan_id: id_rencana).dengan_sub_kegiatan
  end

  def penyebab_permasalahan
    permasalahans.flat_map do |masalah|
      internal = masalah.penyebab_internal&.strip
      external = masalah.penyebab_external&.strip
      [internal, external]
    end.join(".\n")
  end

  def penyebab_permasalahan_html
    permasalahans.flat_map do |masalah|
      internal = masalah.penyebab_internal&.strip
      external = masalah.penyebab_external&.strip
      ["- #{internal}", "- #{external}"]
    end.join("<br>").html_safe
  end

  def permasalahan_sasaran
    permasalahans.map(&:permasalahan).join('.')
  end

  def in_gender?
    genders.any?
  end

  def gambaran_umum_sasaran
    latar_belakangs.map(&:gambaran_umum).join('.')
  end

  def strategi?
    strategi.present?
  end

  def tahapan?
    tahapans.exists?
  end

  def renaksi?
    tahapans.any? { |th| th.aksis.any? }
  end

  def manual_ik?
    indikator_sasarans.any?(&:manual_ik)
  end

  def indikator?
    indikator_sasarans.any? { |ind| ind&.target&.present? && ind&.satuan&.present? && ind&.indikator_kinerja&.present? }
  end

  def anggaran?
    tahapans.any? { |th| th.anggarans.any? }
  end

  def output_terisi?
    metadata.key?("hasil_output")
  rescue NoMethodError
    false
  end

  def output_inovasi_terisi?
    metadata.key?("hasil_inovasi")
  rescue NoMethodError
    false
  end

  def hasil_inovasi_sasaran
    metadata&.dig("hasil_inovasi")
  end

  def jenis_inovasi_sasaran
    metadata&.dig("jenis_inovasi")
  end

  def inovasi_sasaran
    metadata&.dig("inovasi_sasaran")
  end

  def gambaran_nilai_kebaruan_sasaran
    metadata&.dig("gambaran_nilai_kebaruan")
  end

  def sasaran_inovasi
    punya_inovasi? ? inovasi_sasaran : ''
  end

  def sasaran_hasil_inovasi
    punya_inovasi? ? hasil_inovasi_sasaran : ''
  end

  def sasaran_jenis_inovasi
    punya_inovasi? ? jenis_inovasi_sasaran : ''
  end

  def sasaran_gambaran_inovasi
    punya_inovasi? ? gambaran_nilai_kebaruan_sasaran : ''
  end

  def output_sasaran
    metadata&.dig("hasil_output")
  end

  def nama_output_sasaran
    metadata&.dig("nama_output")
  end

  def sasaran_sesuai?
    indikator_sasarans.any? && manual_ik?
  end

  def siap_ditarik?
    if wajib_manrisk
      strategi? && tahapan? && manual_ik? && target_sesuai? && manrisk_diverifikasi?
    else
      strategi? && tahapan? && manual_ik? && target_sesuai?
    end
  end

  def sasaran_kota
    pohon = strategi.pohon
    # return unless pohon.pohonable_type == 'StrategiKotum'

    pohon_kota = pohon.pohonable
    {
      strategi_kota: pohon_kota.strategi,
      sasaran_kota_id: pohon_kota&.sasaran_kotum_id,
      sasaran_kota: pohon_kota&.sasaran_kotum_sasaran
    }
  rescue NoMethodError
    {
      strategi_kota: nil,
      sasaran_kota_id: nil,
      sasaran_kota: nil
    }
  end

  def sasaran_atasan_pohon
    strategi_atasan_now = strategi&.strategi_atasan
    sasaran_atasan_now = strategi_atasan_now&.sasarans
    {
      strategi_atasan: strategi_atasan_now&.strategi,
      sasaran_atasan_id: sasaran_atasan_now&.first&.id_rencana,
      sasaran_atasan: sasaran_atasan_now&.first&.sasaran_kinerja,
      nama_atasan: sasaran_atasan_now&.first&.user&.nama_nip
    }
  end

  def kegiatan
    program_kegiatan.present? ? program_kegiatan.nama_kegiatan : 'Belum diisi'
  end

  def subkegiatan
    program_kegiatan.present? ? program_kegiatan.nama_subkegiatan : 'Belum diisi'
  end

  def subkegiatan_kode_sub
    "#{subkegiatan}-(#{kode_subkegiatan})"
  end

  def program_sasaran
    program_kegiatan.nama_program
  rescue NoMethodError
    'Kosong'
  end

  def kegiatan_sasaran
    program_kegiatan.nama_kegiatan
  rescue NoMethodError
    'Kosong'
  end

  def subkegiatan_sasaran
    program_kegiatan.nama_subkegiatan
  rescue NoMethodError
    'Kosong'
  end

  def kode_program
    program_kegiatan.present? ? program_kegiatan.kode_program : '-'
  end

  def kode_subkegiatan
    program_kegiatan.present? ? program_kegiatan.kode_sub_giat : ' '
  end

  def kode_subkegiatan_sasaran
    program_kegiatan.kode_sub_giat
  end

  # @doc get tahapan rencana aksi sasaran with correct sort
  def tahapan_renaksi
    tahapans.includes([:anggarans]).sort_by do |thp|
      thp.urutan.to_i
    end
  end

  def nama_pemilik
    user.nama
  rescue NoMethodError
    'nama kosong!!'
  end

  def nip_pemilik
    user.nik
  rescue NoMethodError
    'asn tidak aktif!!'
  end

  def nama_nip_pemilik
    user.nama_nip_kurung_small
  end

  def clone_dari
    return unless id_rencana.include?('clone')

    Sasaran.find(clone_asli)
  end

  def renaksi_cloner
    clone_asal = clone_dari

    return unless clone_asal

    return unless clone_asal.tahapans.any?

    clone_asal.tahapans.each do |tahap|
      clone = TahapanCloner.call(tahap, id_rencana_sas: id_rencana,
                                        traits: %i[normal])
      clone.persist

      new_tahapan = clone.to_record

      id_rencana_aksi_new = new_tahapan.id_rencana_aksi

      tahap.aksis.each do |aksi|
        clone_aksi = AksiCloner.call(aksi, id_rencana_aksi: id_rencana_aksi_new)
        clone_aksi.persist
      end
    end
  end

  def anggaran_sasaran
    tahapans.includes(%i[anggarans]).map(&:rekening_anggaran)
  end

  def map_sasaran_atasan
    strategi.strategi_eselon_tiga.sasaran
  end

  def sasaran_dan_indikator
    "#{opd&.nama_opd} - #{sasaran_kinerja} - indikator: #{indikator_sasarans.pluck(:indikator_kinerja).flatten}"
  end

  def sasaran_dan_indikator_dan_subkegiatan
    "#{opd&.nama_opd} - #{sasaran_kinerja} - indikator: #{indikator_sasarans.pluck(:indikator_kinerja).flatten} - subkegiatan: #{subkegiatan}"
  end

  def anggaran_spbe
    sasaran_milik == 'spbe' ? anggaran : total_anggaran
  end

  def strategi_atasan
    if strategi&.strategi_dihapus?
      "Pohon sudah dihapus, edit rekin untuk perbaiki"
    else
      strategi.strategi_atasan
    end
  rescue NoMethodError
    'Kosong'
  end

  def strategi_sasaran
    if strategi&.strategi_dihapus?
      "Pohon sudah dihapus, edit rekin untuk perbaiki"
    else
      strategi.strategi
    end
  rescue NoMethodError
    'Kosong'
  end

  def role_strategi_sasaran
    strategi&.role
  rescue NoMethodError
    'Kosong'
  end

  def status_ekak
    tahun_bener = tahun.include?('murni') ? tahun[/[^_]\d*/, 0] : tahun
    if tahun_bener.match?('perubahan')
      'E-KAK Perubahan'
    else
      'E-KAK'
    end
  end

  def status_terisi
    {
      indikator_sasaran: indikator?,
      manual_ik: manual_ik?,
      tahapan: tahapan?,
      renaksi: renaksi?,
      anggaran: anggaran?,
      total: total_anggaran
    }
  end

  def kuncian(jenis)
    Kunci.find_by(kunciable_id: id,
                  kunciable_type: 'Sasaran',
                  jenis: jenis)
  end

  def seluruh_anggaran
    [
      { jenis: 'rankir1', total: total_anggaran_rankir_1, keterangan: kuncian('rankir1')&.keterangan,
        status: kuncian('rankir1')&.status_kunci },
      { jenis: 'rankir2', total: total_anggaran, keterangan: kuncian('rankir2')&.keterangan,
        status: kuncian('rankir2')&.status_kunci },
      { jenis: 'penetapan', total: total_anggaran_penetapan, keterangan: kuncian('penetapan')&.keterangan,
        status: kuncian('penetapan')&.status_kunci }
    ]
  end

  def anggaran_genders
    genders.map(&:anggaran_gender).flatten.sum
  end

  def pemilik
    nip_asn.present? ? User.find_by(nik: nip_asn) : User.find_by(nik: nip_asn_sebelumnya)
  end

  def pemilik_asli?
    nip_asn == nip_asn_sebelumnya || nip_asn_sebelumnya.nil?
  end

  # alias method indikator_sasarans
  def indikators
    indikator_sasarans
  end

  def shown_indikators
    indikator_sasarans.shown
  end

  def mandatori_sasaran(tahun)
    mandatoris.where(tahun: tahun)
              .select { |mand| mand.dasar_hukum.length > 1 }
  end

  def dasar_hukum_sasaran
    dasar_hukums.select { |das_hu| das_hu.dasar_hukum.length > 1 }
  end

  def all_dasar_hukum(tahun)
    dasar_hukum_sasaran + mandatori_sasaran(tahun)
  end

  def nama_pelaksana
    user.nama
  rescue NoMethodError
    'User tidak ditemukan'
  end

  def role
    'sub_operational_pohon_kota'
  end

  def dampak_resiko_setuju?
    status_dampak_resiko == "Setuju"
  end

  def dampak_resiko_ditolak?
    status_dampak_resiko == "Tolak"
  end

  def tahapan_mr?
    tahapans.any?(&:rtp_mr?) && tahapans.any?(&:tahapan_valid?)
  end

  def dampak_resiko_verif?
    status_dampak_resiko.present?
  end

  def strategi_bawahan_eselon3
    return if user.eselon_user != 'eselon_3'

    strategi.strategi_bawahans.where(tahun: tahun)
  end

  def sasaran_bawahan_eselon3_diverifikasi
    return if user.eselon_user != 'eselon_3'

    strategi_bawahan_eselon3.flat_map(&:sasaran_bawahan_manrisk)
  end

  # Check this, the logic is change
  # from sasarans to pohons
  def manrisk_diverifikasi?
    if strategi&.strategi_eselon3
      sasaran_bawahan_eselon3_diverifikasi.all?(true)
    else
      dampak_resiko_setuju?
    end
  end

  def status_manrisk
    if dampak_resiko_setuju?
      'disetujui'
    elsif dampak_resiko_ditolak?
      'ditolak'
    elsif rincian&.resiko.present? && permasalahans.any?
      'siap_dinilai'
    else
      'belum_siap'
    end
  end

  def punya_online?
    rincian.model_layanan == 'Online'
  end

  def punya_inovasi?
    hasil_inovasi == 'Inovasi'
  end

  def inovasi_lolos?
    inovasi_lolos
  end

  def inovasi_lolos_button
    if inovasi_lolos?
      "<div class='btn btn-sm btn-success text-white'><i class='fas fa-check me-2'></i>LOLOS</div>".html_safe
    else
      ''
    end
  end

  def toggle_inovasi_lolos
    self.inovasi_lolos = !inovasi_lolos
    save
  end

  def verifikator_manrisk?
    strategi.role.in? %w[eselon_3 plt]
  end

  def user_manrisk?
    user.has_role?(:eselon_4) && !strategi&.as_plt?
  end

  def wajib_manrisk
    return false if tahun.nil?

    tahun_bener = tahun[/[^_]\d*/, 0].to_i
    user_manrisk? && strategi&.strategi_eselon4 && tahun_bener > 2024
  end

  def default_urutan_tahapan
    tahapans.size
  end

  def termasuk_program_unggulan?
    usulans.any? { |us| us.usulanable_type == 'Inovasi' }
  end

  def rtp_sasaran
    tahapans.select(&:rtp_mr?).first
  rescue NoMethodError
    '--RTP-BELUM-DIPILIH--'
  end

  def perintah_walikota?
    is_perintah_walikota
  end
end
