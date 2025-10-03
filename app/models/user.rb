# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  atasan                 :string
#  atasan_nama            :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  eselon                 :string
#  id_bidang              :bigint
#  jabatan                :string
#  kode_opd               :string
#  metadata               :jsonb
#  nama                   :string
#  nama_bidang            :string
#  nama_pangkat           :string
#  nik                    :string
#  nip_sebelum            :string
#  pangkat                :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  type                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  lembaga_id             :integer          default(1)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_nik                   (nik) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
  # validates :nama, presence: true
  # validates :nik, presence: true
  belongs_to :opd, foreign_key: 'kode_opd', primary_key: 'kode_opd'
  belongs_to :lembaga, optional: true
  has_many :kaks
  has_many :sasarans, dependent: :destroy, foreign_key: 'nip_asn', primary_key: 'nik'
  has_many :strategis, dependent: :destroy, foreign_key: 'nip_asn', primary_key: 'nik'
  # has_many :program_kegiatans, through: :sasarans
  has_many :pohons, dependent: :destroy
  # usulan user
  has_many :musrenbangs, foreign_key: 'nip_asn', primary_key: 'nik'
  has_many :pokpirs, foreign_key: 'nip_asn', primary_key: 'nik'
  has_many :mandatoris, foreign_key: 'nip_asn', primary_key: 'nik'
  has_many :inovasis, foreign_key: 'nip_asn', primary_key: 'nik'
  has_many :jabatan_users, foreign_key: 'nip_asn', primary_key: 'nik'

  has_one :detail_pegawai, primary_key: 'nik', foreign_key: 'nip'

  has_and_belongs_to_many :indikators do
    def by_strategi_id(strategi_id)
      where(indikators_users: { strategi_id: strategi_id })
    end
  end

  # WARNING: many bug in here because added role
  scope :khusus, -> { with_any_role(:admin, :super_admin, :reviewer, :guest, :khusus, :admin_kabupaten) }
  scope :admin, -> { with_role(:admin) }
  scope :reviewer, -> { with_role(:reviewer) }
  scope :guest, -> { with_role(:guest) }
  scope :non_admin, -> { without_role(:admin) }
  scope :aktif, -> { without_role([:non_aktif]) }
  scope :asn_aktif, -> { without_role([:admin]).with_role("eselon_4").order(:nama) }
  scope :sasaran_asn_aktif, -> { asn_aktif.joins(:sasarans).merge(Sasaran.dengan_rincian) }
  scope :sasaran_diajukan, lambda {
                             asn_aktif.includes(:sasarans, :program_kegiatans).merge(Sasaran.sudah_lengkap)
                           } # depreceated
  scope :opd_by_role, ->(kode_opd, role) { where(kode_opd: kode_opd).with_role(role.to_sym) }
  scope :eselon2, -> { with_role("eselon_2") }
  scope :eselon2b, -> { with_role("eselon_2b") }
  scope :eselon3, -> { with_role("eselon_3") }
  scope :eselon4, -> { with_role("eselon_4") }
  scope :staff, -> { with_role("staff") }
  scope :mandatori_setuju, lambda {
    mandatoris.where(status: 'aktif')
  }
  # after_update :update_sasaran
  after_create :assign_default_role

  validates :nama, presence: true
  validates :nik, presence: true

  attr_writer :login

  self.inheritance_column = ''

  store_accessor :metadata, :tim_id, :role_tim, :processed_at,
                 :assigned_by, :keterangan_tim, :tahun_tim, :opd_tim

  def to_s
    nama
  end

  def nik_pegawai
    client = Api::SandiDataClient.new(nama, nik, '')
    client.decrypt_nik
  rescue NoMethodError
    ''
  end

  def super_admin?
    has_role?(:super_admin) && id == 1
  end

  def admin_kota?
    has_role?(:super_admin)
  end

  def admin?
    has_any_role?(:super_admin, :admin)
  end

  def nip_asn
    nik
  end

  def login
    @login || nik || email
  end

  def nama_jabatan_terakhir
    if jabatan_users.any?
      jabatan_users.last.nama_jabatan
    else
      jabatan
    end
  end

  def opd_terakhir
    if jabatan_users.any?
      jabatan_users.last.opd
    else
      opd
    end
  end

  def nama_opd_terakhir
    if jabatan_users.any?
      jabatan_users.last.opd.nama_opd
    else
      opd.nama_opd
    end
  end

  def tahun_jabatan
    if jabatan_users.any?
      jabatan_users.last.tahun
    else
      created_at.year.to_s
    end
  end

  def status_kepegawaian
    "PNS"
  end

  def strategi_pohons(strategi_id)
    pohons.where(strategi_id: strategi_id)
  end

  def strategi_pohon_diterima(strategi_id, opd_id)
    sps = strategi_pohons(strategi_id)
          .where.not(status: 'pelaksana-batal', pohonable_type: ['', nil])
    sps.select { |sp| sp.pohonable.opd_id == opd_id.to_s }
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(['lower(nik) = :value OR lower(email) = :value',
                                    { value: login.downcase }]).first
    elsif conditions.key?(:nik) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end

  def assign_default_role
    add_role(:asn) if roles.blank?
  end

  delegate :nama_opd, to: :opd

  def after_pindah(tahun)
    nulify_sasaran(tahun)
    nulify_strategi(tahun)
  end

  def nulify_sasaran(tahun)
    Sasaran.where(nip_asn: nik, tahun: tahun).update_all(nip_asn_sebelumnya: nik, nip_asn: nil)
  end

  def nulify_strategi(tahun)
    Strategi.where(nip_asn: nik, tahun: tahun).update_all(nip_asn_sebelumnya: nik, nip_asn: nil)
  end

  def update_sasaran
    Sasaran.where(nip_asn_sebelumnya: nip_sebelum).update_all(nip_asn: nik)
  end

  def update_strategi
    Strategi.where(nip_asn_sebelumnya: nip_sebelum).update_all(nip_asn: nik)
  end

  def aktifkan_user
    remove_role :non_aktif if has_role? :non_aktif
    add_role(:asn) unless has_role? :asn
  end

  def nonaktifkan_user
    remove_role(:asn) if has_role? :asn
    add_role(:non_aktif) unless has_role? :admin
  end

  def sasaran_aktif
    program = program_kegiatan_sasarans.count
    usulan = sasarans.map(&:usulans).flatten.count
    {
      program_aktif: program,
      usulan_aktif: usulan
    }
  end

  def sasaran_untuk_dashboard(tahun, opd_id)
    sasarans.includes(%i[strategi
                         user
                         tahapans
                         program_kegiatan
                         indikator_sasarans])
            .where(tahun: tahun)
            .order(nip_asn: :asc)
            # filter by current opd aktif
            .dengan_strategi
            .select do |sas|
      if sas.strategi?
        sas.strategi.opd_id == opd_id
      else
        true
      end
    end
  end

  def sasarans_tahun(tahun)
    sasarans.includes(%i[strategi
                         user
                         tahapans
                         program_kegiatan
                         indikator_sasarans])
            .where(tahun: tahun)
            .order(nip_asn: :asc)
            .dengan_strategi
  end

  def subkegiatan_sasarans_tahun(tahun)
    sasarans_tahun(tahun).group_by(&:program_kegiatan)
  end

  def legacy_sasaran_user(tahun)
    sasarans.includes(%i[strategi tahapans program_kegiatan indikator_sasarans user])
            .or(Sasaran.cari_nip_asn_sebelumnya(nip))
            .filter { |sas| sas.tahun =~ /.*(#{tahun})/i }
            .group_by(&:program_kegiatan)
  end

  def program_sasarans_tahun(tahun)
    sasarans_tahun(tahun)
      .index_with { |str| str.strategi.subkegiatans_sasarans }
  end

  def sasarans_all_tahun(tahun)
    sasarans
      .includes(%i[strategi
                   user
                   tahapans
                   program_kegiatan
                   indikator_sasarans])
      .where("COALESCE(tahun, '') ILIKE ?", "%#{tahun}%")
  end

  def subkegiatan_sasarans_all_tahun(tahun)
    sasarans_all_tahun(tahun).group_by(&:subkegiatan)
  end

  def mandatoris_tahun(tahun)
    mandatoris.where("COALESCE(tahun, '') ILIKE ?", "%#{tahun}%")
  end

  def program_kegiatan_sasarans(tahun: 2022)
    # TODO: clean this up
    sasarans.where(tahun: tahun)
            .map(&:program_kegiatan)
            .compact
            .uniq
  end

  def jumlah_sasaran
    @program_kegiatan_sasarans.map { |j| j.sasarans.count }.flatten.reduce(:+)
  end

  def jumlah_anggaran
    @program_kegiatan_sasarans.map { |j| j&.my_pagu }.flatten.reduce(:+)
  end

  def sasaran_program
    sasarans.includes(%i[program_kegiatan
                         rincian
                         permasalahans
                         dasar_hukums
                         latar_belakangs
                         usulans
                         tahapans]).group_by(&:program_kegiatan)
  end

  def petunjuk_sasaran
    {
      merah: total_hangus,
      kuning: kurang_lengkap,
      biru: biru,
      hijau: hijau
    }
  end

  def pegawai_kelurahan?
    jabatan&.upcase&.include?('KELURAHAN')
  end

  def pegawai_puskesmas?
    nama_bidang&.upcase&.include?('PUSKESMAS')
  end

  def pegawai_bpbd?
    opd.nama_opd&.upcase&.include?('BENCANA')
  end

  def petunjuk_kelurahan
    jabatan.upcase.split("KELURAHAN", 2).last.strip if pegawai_kelurahan?
  end

  def petunjuk_puskesmas
    nama_bidang&.upcase&.split("PUSKESMAS", 2)&.last&.strip if pegawai_puskesmas?
  end

  def pegawai_rsud?
    nama_bidang&.upcase&.include?('RUMAH SAKIT')
  end

  def pegawai_bagian?
    nama_bidang&.upcase&.include?('BAGIAN') && kode_opd == '1260'
  end

  def petunjuk_bagian
    nama_bidang.upcase.split("BAGIAN", 2).last.strip if pegawai_bagian?
  end

  def petunjuk_status
    @petunjuk_status ||= sasarans.map(&:petunjuk_status)
  end

  def biru
    @biru ||= petunjuk_status.select { |s| s[:usulan_dan_sub] }
                             .select { |j| j.except(:usulan_dan_sub).values.any?(false) }
                             .count
  end

  def hijau
    @hijau ||= petunjuk_status.map(&:values).select { |s| s.all?(true) }.count
  end

  def total_hangus
    @total_hangus ||= sasarans.total_hangus
  end

  def kurang_lengkap
    @kurang_lengkap ||= sasarans.select { |s| s.usulans.exists? && s.belum_ada_sub? }.count
  end

  def nama_atasan
    atasan_nama or '-'
  end

  def sasaran_asn_sync_skp(tahun: nil)
    sasaran_all = sasarans.includes(:tahapans)
                          .where.not(tahapans: { id_rencana: nil })
                          .where("sasarans.tahun ILIKE ?", "%#{tahun}%")
                          .dengan_strategi
    sasaran_all.select(&:siap_ditarik?)
  end

  def sasaran_pohon_kinerja(tahun: nil)
    sasarans.includes(%i[strategi indikator_sasarans])
            .where("sasarans.tahun ILIKE ?", "%#{tahun}%")
            .select { |s| s.tahapan? && s.manual_ik? && s.strategi? && s.target_sesuai? }
  end

  def sasaran_pohon_kinerja_periode(periode)
    sasaran_opds = sasarans.includes([:strategi, { indikator_sasarans: [:manual_ik] }])
                           .where(tahun: periode)
                           .select { |s| s.tahapan? && s.manual_ik? && s.strategi? && s.target_sesuai? }
    sasaran_opds.group_by(&:sasaran_kinerja).transform_values do |sasarans|
      sasarans.flat_map { |sas| sas.indikator_sasarans }.group_by do |ind|
        [ind.indikator_kinerja, ind.rumus_perhitungan, ind.sumber_data]
      end.transform_values do |inds|
        inds.to_h { |inn| [inn.sasaran.tahun, [inn.target, inn.satuan]] }
      end
    end
  end

  def eselon_user
    eselon = roles.where("roles.name ilike ?", "%eselon%").first
    eselon_user = eselon.nil? ? roles.where("roles.name ilike ?", "%staff%").first : eselon
    eselon_user.nil? ? "no_eselon" : eselon_user.name
  end

  def eselon_atas?
    if pegawai_puskesmas? || pegawai_bpbd? || pegawai_rsud?
      eselon_user == 'eselon_2b'
    else
      eselon_user == 'eselon_3' || eselon_user == 'eselon_2b'
    end
  end

  def role_asn
    roles.where("roles.name ilike ?", "%eselon%")
         .or(roles.where("roles.name ilike ?", "%staff%"))
         .pluck(:name)
  end

  def role_name
    roles.pluck(:name)
  end

  def isi_renaksi?
    role_asn.any? { |es| %w[eselon_4 staff].include?(es) }
  end

  def nama_nip
    "#{nama} - #{nik}"
  rescue NoMethodError
    'NAMA NIP KOSONG'
  end

  def nama_nip_kurung
    "#{nama} ( #{nik} )"
  rescue NoMethodError
    'NAMA NIP KOSONG'
  end

  def nama_nip_kurung_small
    "#{nama} (#{nik})"
  rescue NoMethodError
    'NAMA NIP KOSONG'
  end

  def nip
    nik
  end

  def subkegiatan
    sasarans.joins(:program_kegiatan).group_by(&:kode_subkegiatan_sasaran)
  end

  def subkegiatan_by_sasaran_tahun(tahun)
    subkegiatan.transform_values do |val|
      val.select { |sas| sas.tahun == tahun }
    end
  end

  def subkegiatan_sudah_lengkap(tahun)
    sasarans.sudah_lengkap
            .where(tahun: tahun,
                   program_kegiatan: { kode_opd: opd.kode_opd })
            .group_by(&:kode_subkegiatan_sasaran)
  end

  def subkegiatan_sasaran_lengkap_tahun(tahun)
    subkegiatan_sudah_lengkap.transform_values do |val|
      val.select { |sas| sas.tahun == tahun }
    end
  end

  def subkegiatan_lengkap_by_tahun(tahun)
    sasarans
      .sudah_lengkap
      .where('sasarans.tahun ILIKE ?',
             "%#{tahun}%").order(:id)
  end

  def usulans_user
    opd.usulans
  end

  def self.grouped_collection_by_role
    {
      'eselon_2' => User.eselon2.limit(10),
      'eselon_3' => User.eselon3.limit(10),
      'eselon_4' => User.eselon4.limit(10),
      'staff' => User.staff.limit(10),
      'admin' => User.admin.limit(10),
      'reviewer' => User.reviewer.limit(10),
      'guest' => User.guest.limit(10)
    }
  end

  def opd_bidang_user
    Opd.find_by(kode_opd: kode_opd, id_bidang: id_bidang)
  end

  def nik=(nik)
    write_attribute(:nik, nik.try(:strip))
  end

  def email=(email)
    write_attribute(:email, email.try(:strip))
  end

  # list opd dalam default dan jabatan
  # untuk menampung opd plt
  def all_kode_opd
    default_kode_opd = [kode_opd]
    if jabatan_users.aktif.any?
      jabatan_users.map { |jab| jab.opd.kode_opd } + default_kode_opd
    else
      default_kode_opd
    end
  end

  # jabatan_users with status and opd
  def jabatan_user_in_opd(kode_opd: '')
    if jabatan_users.any?
      jabatan_users.find_by(kode_opd: kode_opd).jabatan_status
    else
      "#{opd} - [default]"
    end
  end

  def jabatan_plt?
    jabatan_users.any? { |jab| jab.status == 'plt' }
  end
end
