# == Schema Information
#
# Table name: opds
#
#  id                 :bigint           not null, primary key
#  bidang_urusan      :string
#  has_bidang         :boolean          default(FALSE)
#  id_bidang          :integer
#  id_daerah          :string
#  id_opd_skp         :integer
#  is_bagian          :boolean          default(FALSE)
#  is_bidang          :boolean          default(FALSE)
#  is_kota            :boolean          default(FALSE)
#  kode_bidang_urusan :string
#  kode_opd           :string
#  kode_opd_induk     :string
#  kode_unik_opd      :string
#  kode_urusan        :string
#  nama_kepala        :string
#  nama_opd           :string
#  nip_kepala         :string
#  pangkat_kepala     :string
#  status_kepala      :string
#  tahun              :string
#  urusan             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  lembaga_id         :integer
#
# Indexes
#
#  index_opds_on_kode_unik_opd_and_lembaga_id  (kode_unik_opd,lembaga_id) UNIQUE
#
class Opd < ApplicationRecord
  validates :nama_opd, presence: true
  validates :kode_opd, presence: true
  has_many :asets, primary_key: :kode_unik_opd, foreign_key: :kode_unik_opd
  has_many :jabatans, -> { order('nilai_jabatan DESC') }, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd'
  has_many :users, foreign_key: 'kode_opd', primary_key: 'kode_opd'
  has_many :jabatan_users, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd'
  has_many :sasarans, through: :users
  has_many :indikator_sasarans, through: :sasarans
  has_many :program_kegiatans, foreign_key: 'kode_skpd', primary_key: 'kode_unik_opd' do
    def programs
      where.not(kode_skpd: [nil, ""])
           .uniq { |pk| pk.values_at(:kode_program, :kode_sub_skpd) }
           .sort_by { |pk| pk.values_at(:kode_program, :kode_skpd) }
    end
  end
  belongs_to :lembaga
  has_many :sasaran_opds, foreign_key: 'kode_unik_opd', primary_key: 'kode_unik_opd'
  has_many :tujuan_opds, class_name: 'TujuanOpd', foreign_key: 'kode_unik_opd', primary_key: 'kode_unik_opd'
  # has_one :kepala, class_name: 'Kepala', foreign_key: :nik, primary_key: :nip_kepala

  # kotak usulan opd
  has_many :usulans, dependent: :destroy
  has_many :pohons, dependent: :destroy
  has_many :isu_strategis_opds, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd'
  has_many :strategis
  has_many :komentars, lambda {
    where(jenis: "OPD")
  }, primary_key: :id, foreign_key: :item
  belongs_to :opd_induk, class_name: 'Opd', primary_key: 'kode_unik_opd', foreign_key: 'kode_opd_induk',
                         optional: true
  has_many :bidangs, class_name: 'Opd', foreign_key: 'kode_opd_induk', primary_key: 'kode_unik_opd'

  has_many :lppd_outcome, lambda {
                            where(jenis: 'LPPD', sub_jenis: 'Outcome').order(id: :desc)
                          }, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd', class_name: 'Indikator'
  has_many :lppd_output, lambda {
                           where(jenis: 'LPPD', sub_jenis: 'Output').order(id: :desc)
                         }, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd', class_name: 'Indikator'
  has_many :spm_outcome, lambda {
                           where(jenis: 'SPM', sub_jenis: 'Outcome').order(id: :desc)
                         }, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd', class_name: 'Indikator'
  has_many :spm_output, lambda {
                          where(jenis: 'SPM', sub_jenis: 'Output').order(id: :desc)
                        }, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd', class_name: 'Indikator'
  has_many :sdgs_outcome, lambda {
                            where(jenis: 'SDGS', sub_jenis: 'Outcome').order(id: :desc)
                          }, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd', class_name: 'Indikator'
  has_many :sdgs_output, lambda {
                           where(jenis: 'SDGS', sub_jenis: 'Output').order(id: :desc)
                         }, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd', class_name: 'Indikator'
  has_many :rb_outcome, lambda {
                          where(jenis: 'RB', sub_jenis: 'Outcome').order(id: :desc)
                        }, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd', class_name: 'Indikator'
  has_many :rb_output, lambda {
                         where(jenis: 'RB', sub_jenis: 'Output').order(id: :desc)
                       }, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd', class_name: 'Indikator'

  has_many :masalah_terpilih, lambda {
                                where(terpilih: true)
                              }, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd', class_name: 'AkarMasalah'

  accepts_nested_attributes_for :indikator_sasarans, reject_if: :all_blank, allow_destroy: true

  default_scope { where(is_kota: false) }
  scope :opd_resmi, -> { where.not(kode_unik_opd: nil) }
  scope :opd_resmi_kota, -> { where.not(kode_unik_opd: nil).or(Opd.unscoped.where(is_kota: true)) }
  scope :with_bidang, -> { where(has_bidang: true) }
  scope :with_user, -> { joins(:users).merge(User.eselon2).where.not(id: 1).distinct.order(:kode_unik_opd) }

  before_validation :create_kode_opd, if: :new_opd?

  def create_kode_opd
    self.kode_opd = SecureRandom.random_number(10**4)
  end

  def new_opd?
    kode_opd.nil?
  end

  def to_s
    nama_opd
  end

  def nama_lembaga_opd
    "#{nama_opd} - #{lembaga}"
  end

  def susunan_renja
    program_kegiatans.urusans
  end

  def program_renstra
    program_kegiatans.programs
  end

  def sasaran_program_opds
    program_renstra
  end

  def pagu_program_rankir
    program_kegiatans.programs.map(&:my_pagu).compact.sum
  end

  def kegiatans_renstra
    ProgramKegiatan.where(kode_opd: kode_opd)
                   .where.not(kode_skpd: [nil, ""])
                   .uniq { |pk| pk.values_at(:kode_giat, :id_sub_unit) }
                   .sort_by { |pk| pk.values_at(:kode_giat) }
  end

  def subkegiatans_renstra
    ProgramKegiatan.where(kode_opd: kode_opd)
                   .where.not(kode_skpd: [nil, ""])
                   .uniq { |pk| pk.values_at(:kode_sub_giat, :id_sub_unit) }
                   .sort_by { |pk| pk.values_at(:kode_sub_giat) }
  end

  def text_urusan
    return nil unless urusan

    "#{kode_urusan} #{urusan.capitalize}"
  end

  def text_bidang_urusan
    return nil unless bidang_urusan

    "#{kode_bidang_urusan} #{bidang_urusan.capitalize}"
  end

  def jabatan_kepala
    jabatan = User.find_by(nik: nip_kepala.delete(" \t\r\n")).jabatan

    nip_kepala.match?(/(-plt)/) ? "plt. #{jabatan}" : jabatan
  rescue NoMethodError
    'Kepala'
  end

  def nip_kepala_fix_plt
    return if nip_kepala.nil?

    nip_kepala.match?(/(-plt)/) ? nip_kepala.gsub!(/(-plt)/, '') : nip_kepala
  end

  def jabatan_kepala_tanpa_opd
    jabatan_kepala.gsub!(/(?<=kepala).+/i, '')
  rescue NoMethodError
    'Kepala'
  end

  def musrenbang_opd
    Musrenbang.where(opd: id_opd_skp)
  end

  def pokpir_opd
    Pokpir.where(opd: id_opd_skp)
  end

  def strategi_eselon2
    strategis.where(role: "eselon_2")
  end

  def strategi_eselon2b
    strategis.where(role: "eselon_2b")
  end

  def strategi_eselon3
    strategis.where(role: "eselon_3")
  end

  def strategi_eselon4
    strategis.where(role: "eselon_4").reject(&:strategi_dihapus?)
  end

  def strategi_staff
    strategis.where(role: "staff")
  end

  def sasaran_eselon2
    strategi_eselon2.map(&:sasaran)
  end

  def sasaran_eselon3
    strategi_eselon3
      .joins("INNER JOIN sasarans ON cast (sasarans.strategi_id as INT) = strategis.id")
      .map(&:sasaran)
  end

  def sasaran_eselon4
    strategi_eselon4
      .joins("INNER JOIN sasarans ON cast (sasarans.strategi_id as INT) = strategis.id")
      .map(&:sasaran)
  end

  def sasaran_eselon4_limit(tahun:, limit: 25)
    strategi_eselon4
      .where(tahun: tahun)
      .joins("INNER JOIN sasarans ON cast (sasarans.strategi_id as INT) = strategis.id")
      .where(sasarans: { tahun: tahun })
      .limit(limit)
      .map(&:sasaran)
  end

  def eselon_dua_opd
    raise 'format kode opd salah' if kode_unik_opd.length != 22

    if kode_unik_opd.last == '0'
      users.with_role("eselon_2").first
    else
      opd_pusat = Opd.find_by(kode_unik_opd: kode_opd_to_induk_opd)
      opd_pusat.eselon_dua_opd
    end
  end

  def kode_opd_to_induk_opd
    kode_unik_opd.gsub(/\d$/, '0')
  end

  def pohon_opd
    pohons.where(pohons: { pohonable_type: %w[StrategiKotum IsuStrategisOpd] })
  end

  def unique_isu_pohon_opd
    pohon_opd.uniq { |pohon| pohon.pohonable.isu }.map { |bb| bb.pohonable.isu }
  end

  def isu_strategis_pohon(tahun)
    unique_isu_pohon_opd
      .select { |isu| isu.tahun.match(/#{tahun}(\S*|\b)/) }
  end

  def strategi_kepala_by_strategi_kota(pohon_id)
    strategis.where(pohon_id: pohon_id, role: "eselon_2").pluck(:strategi).map.with_index(1) do |ss, no|
      "#{no}. #{ss}\n"
    end
  end

  def strategi_kepala_by_strategi_kota_untuk_excel(pohon_id)
    strategis.where(pohon_id: pohon_id, role: "eselon_2")
  end

  def sasaran_opds_pohon
    strategis.where(role: 'eselon_2').map(&:sasaran)
  end

  def pohon_kinerja_opd(tahun)
    isu_strategis_pohon(tahun).to_h do |isu_kota|
      [isu_kota, strategi_kota_opd(isu_kota)]
    end
  end

  def strategi_kota_opd(isu_kota)
    isu_kota.strategis_opd(id).to_h do |str_kota_opd|
      [str_kota_opd, strategi_opd(str_kota_opd)]
    end
  end

  def strategi_opd(str_kota_opd)
    if id == 145 || kode_opd == '1260'
      str_kota_opd.strategis_opd(id).to_h do |str_kaopd|
        [str_kaopd, tactical_setda(str_kaopd)]
      end
    else
      str_kota_opd.strategis_opd(id).to_h do |str_kaopd|
        [str_kaopd, tactical_opd(str_kaopd)]
      end
    end
  end

  def tactical_setda(str_kaopd)
    str_kaopd.tactical_2b_objectives.to_h do |str_2b|
      [str_2b, tactical_opd(str_2b)]
    end
  end

  def tactical_opd(str_kaopd)
    str_kaopd.tactical_objectives.to_h do |str_kabid|
      [str_kabid, operational_opd(str_kabid)]
    end
  end

  def operational_opd(str_kabid)
    str_kabid.operational_objectives.to_h do |str_kasi|
      [str_kasi, str_kasi.operational_2_objectives]
    end
  end

  def strategic_tahun(tahun)
    strategi_eselon2.select { |isu| isu.tahun.match(/#{tahun}(\S*|\b)/) }
  end

  def tactical2_tahun(tahun)
    strategi_eselon2b.where.not(strategi_ref_id: "").select { |isu| isu.tahun.match(/#{tahun}(\S*|\b)/) }
  end

  def tactical_tahun(tahun)
    strategi_eselon3.where.not(strategi_ref_id: "").select { |isu| isu.tahun.match(/#{tahun}(\S*|\b)/) }
  end

  def operational_tahun(tahun)
    strategi_eselon4.where.not(strategi_ref_id: "").select { |isu| isu.tahun.match(/#{tahun}(\S*|\b)/) }
  end

  def operational_2_tahun(tahun)
    strategi_staff.where.not(strategi_ref_id: "").select { |isu| isu.tahun.match(/#{tahun}(\S*|\b)/) }
  end

  def indikator_strategic_tahun(tahun)
    strategic_tahun(tahun).map(&:indikator_sasarans).flatten
  end

  def indikator_tactical2_tahun(tahun)
    tactical2_tahun(tahun).map(&:indikator_sasarans).flatten
  end

  def indikator_tactical_tahun(tahun)
    tactical_tahun(tahun).map(&:indikator_sasarans).flatten
  end

  def indikator_operational_tahun(tahun)
    operational_tahun(tahun).map(&:indikator_sasarans).flatten
  end

  def indikator_operational_2_tahun(tahun)
    operational_2_tahun(tahun).map(&:indikator_sasarans).flatten
  end

  def data_total_pokin(tahun)
    {
      strategic: strategic_tahun(tahun).count,
      indikator_strategic: indikator_strategic_tahun(tahun).count,
      tactical: tactical_tahun(tahun).count,
      indikator_tactical: indikator_tactical_tahun(tahun).count,
      operational: operational_tahun(tahun).count,
      indikator_operational: indikator_operational_tahun(tahun).count,
      operational_staff: operational_2_tahun(tahun).count,
      indikator_staff: indikator_operational_2_tahun(tahun).count
    }
  end

  def data_total_pokin_setda(tahun)
    {
      strategic: strategic_tahun(tahun).count,
      indikator_strategic: indikator_strategic_tahun(tahun).count,
      tactical: tactical2_tahun(tahun).count,
      indikator_tactical: indikator_tactical2_tahun(tahun).count,
      tactical2: tactical_tahun(tahun).count,
      indikator_tactical2: indikator_tactical_tahun(tahun).count,
      operational: operational_tahun(tahun).count,
      indikator_operational: indikator_operational_tahun(tahun).count,
      operational_staff: operational_2_tahun(tahun).count,
      indikator_staff: indikator_operational_2_tahun(tahun).count
    }
  end

  def programs_with_strategi_tahun(tahun)
    program_kegiatans
      .programs
      .map { |program| { program => program.sasarans_program(tahun) } }
  end

  def find_sasaran_eselon3(sasaran_kinerja, tahun)
    strategi_eselon3.where(tahun: tahun).flat_map do |strategi|
      sasaran_kinerja_strategi(strategi, sasaran_kinerja)
    end
  end

  def find_strategi_eselon3(cari, tahun)
    strategi_eselon3.where(tahun: tahun)
                    .where.not(type: nil)
                    .where("strategi ILIKE ?", "%#{cari}%")
  end

  def find_sasaran_eselon4(sasaran_kinerja, tahun)
    strategi_eselon4.where(tahun: tahun).flat_map do |strategi|
      sasaran_kinerja_strategi(strategi, sasaran_kinerja)
    end
  end

  def sasaran_kinerja_strategi(strategi, sasaran_kinerja)
    strategi
      .sasarans
      .includes(:indikator_sasarans)
      .where("sasarans.sasaran_kinerja ILIKE ?", "%#{sasaran_kinerja}%")
      .select { |sas| sas.indikator_sasarans.any? && sas.nip_asn.present? && sas.strategi_id.present? }
  end

  def list_strategi_opd(tahun: '')
    strategis.includes(%i[user strategi_atasan]).where(tahun: tahun).group_by(&:role).sort
  end

  def kode_urusans
    kode_urusans = kode_unik_opd.scan(/.{1,5}/).take(3)
    kode_urusans.map do |kode|
      kode.sub(/\.$/, '')
    end
  end

  def list_urusans
    kode_urusan = kode_urusans.map do |kode|
      kode.first
    end
    master_urusan = Master::Urusan.where(kode_urusan: kode_urusan)
                                  .pluck(:kode_urusan,
                                         :nama_urusan)
    urusan_unique = Set.new(master_urusan)
    urusan_unique.to_a
  end

  def list_bidang_urusans
    master_bidang_urusan = Master::BidangUrusan.where(kode_bidang_urusan: kode_urusans)
                                               .pluck(:kode_bidang_urusan,
                                                      :nama_bidang_urusan)
    bidang_urusan_unique = Set.new(master_bidang_urusan)
    bidang_urusan_unique.to_a
  end

  def id_urusans
    kode_urusan = kode_urusans.map do |kode|
      kode.first
    end
    master_urusan_rutin = Master::Urusan.where(kode_urusan: 'X').uniq(&:kode_urusan)
    master_urusan = Master::Urusan.where(kode_urusan: kode_urusan).uniq(&:kode_urusan)
    urusan_unique = Set.new(master_urusan)
    urusans = urusan_unique.to_a
    urusans.prepend(master_urusan_rutin).flatten
  end

  def id_bidang_urusans
    master_bidang_urusan_rutin = Master::BidangUrusan.where(kode_bidang_urusan: 'X.XX').uniq(&:kode_bidang_urusan)
    master_bidang_urusan = Master::BidangUrusan.where(kode_bidang_urusan: kode_urusans).uniq(&:kode_bidang_urusan)
    bidang_urusan_unique = Set.new(master_bidang_urusan)
    bidang_urusans = bidang_urusan_unique.to_a
    bidang_urusans.prepend(master_bidang_urusan_rutin).flatten
  end

  def sasaran_subkegiatans(tahun)
    user_opd = users.aktif.eselon4
    user_opd.map { |user| user.sasarans_tahun(tahun).map(&:program_kegiatan) }.flatten.compact_blank
  end

  def jabatan_baru
    jabatans.where(nilai_jabatan: nil).sort_by { |jab| jab.jenis_jabatan&.nilai }
  end

  def kode_opd_unik
    kode_unik = kode_unik_opd.scan(/.{1,17}/).take(1).first
    Opd.where('kode_unik_opd ILIKE ?', "%#{kode_unik}%").pluck(:kode_unik_opd)
  end

  def aset_opd(_tahun)
    asets.order(:created_at)
  end

  def nama_kode_opd
    [kode_unik_opd, nama_opd]
  end

  def user_bidang
    # baru setda
    if kode_unik_opd == '4.01.0.00.0.00.01.0000'
      Opd.where('kode_unik_opd ILIKE ?', "4.01.0.00.0.00.01%")
         .flat_map { |opd| opd.users.non_admin.aktif }
    else
      users.non_admin.aktif + user_jabatan
    end
  end

  def user_bidang_filter(user_search)
    user_bidang.filter do |user|
      user.nama =~ /.*(#{user_search})/i || user.nik =~ /.*(#{user_search})/i
    end
  end

  def asn_list(nama: '', role: '')
    user_opd = users.where('nama ILIKE ?', "%#{nama}%")
                    .with_any_role(role)
    user_jabatan = if role == 'plt'
                     jabatan_users
                       .joins(:user)
                       .where(status: %w[plt])
                       .map(&:user)
                   else
                     jabatan_users
                       .joins(:user)
                       .where(status: %w[aktif])
                       .map(&:user)
                       .select { |user| user.has_any_role?(role) }
                   end
    user_opd | user_jabatan
  end

  def user_jabatan
    jabatan_users
      .joins(:user)
      .where(status: %w[aktif plt])
      .map(&:user)
  end

  def users_from_jabatan_eselon_4
    user_eselon4 = users.eselon4
    user_jabatan_es4 = user_jabatan.select { |us| us.has_role?(:eselon_4) }
    user_eselon4 + user_jabatan_es4
  end

  def users_jabatans
    user_eselon4_ids = users.pluck(:id)
    user_jabatan_es4_ids = user_jabatan.map(&:id)
    ids = (user_eselon4_ids + user_jabatan_es4_ids).uniq
    User.where(id: ids)
  end

  def opd_setda?
    kode_unik_opd == '4.01.0.00.0.00.01.0000'
  end

  # get all setda whatever in which bagian
  # to get all setda in whichever bagian
  # use the first line
  def setda?
    # kode_unik_opd.in? all_kode_setda
    opd_setda?
  end

  def all_kode_setda
    [
      '4.01.0.00.0.00.01.0000',
      '4.01.0.00.0.00.01.0001',
      '4.01.0.00.0.00.01.0002',
      '4.01.0.00.0.00.01.0003',
      '4.01.0.00.0.00.01.0004',
      '4.01.0.00.0.00.01.0005',
      '4.01.0.00.0.00.01.0006',
      '4.01.0.00.0.00.01.0007'
    ]
  end
end
