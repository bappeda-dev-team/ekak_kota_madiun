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
#  is_bidang          :boolean          default(FALSE)
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
  has_many :users, foreign_key: 'kode_opd', primary_key: 'kode_opd'
  has_many :sasarans, through: :users
  has_many :indikator_sasarans, through: :sasarans
  has_many :program_kegiatans, foreign_key: 'kode_opd', primary_key: 'kode_opd' do
    def programs
      where.not(kode_skpd: [nil, ""])
           .uniq { |pk| pk.values_at(:kode_program, :id_sub_unit) }
           .sort_by { |pk| pk.values_at(:kode_program, :id_sub_unit) }
    end
  end
  belongs_to :lembaga
  has_many :sasaran_opds, foreign_key: 'kode_unik_opd', primary_key: 'kode_unik_opd'
  has_many :tujuan_opds, class_name: 'TujuanOpd', foreign_key: 'kode_unik_opd', primary_key: 'kode_unik_opd'
  # has_one :kepala, class_name: 'Kepala', foreign_key: :nik, primary_key: :nip_kepala

  # kotak usulan opd
  has_many :usulans, dependent: :destroy
  has_many :pohons, dependent: :destroy
  has_many :isu_strategis_opds, foreign_key: 'kode_opd', primary_key: 'kode_opd'
  has_many :strategis, -> { where(type: nil) }
  has_many :komentars, lambda {
    where(jenis: "OPD")
  }, primary_key: :id, foreign_key: :item
  belongs_to :opd_induk, class_name: 'Opd', primary_key: 'kode_unik_opd', foreign_key: 'kode_opd_induk', optional: true
  has_many :bidangs, class_name: 'Opd', foreign_key: 'kode_opd_induk', primary_key: 'kode_unik_opd'

  accepts_nested_attributes_for :indikator_sasarans, reject_if: :all_blank, allow_destroy: true

  scope :opd_resmi, -> { where.not(kode_unik_opd: nil) }
  scope :with_bidang, -> { where(has_bidang: true) }

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

  def pagu_program_rankir
    program_kegiatans.programs.map(&:my_pagu).compact.sum
  end

  def kegiatans_renstra
    ProgramKegiatan.where(kode_opd: kode_opd)
                   .where.not(kode_skpd: [nil, ""])
                   .uniq { |pk| pk.values_at(:kode_giat, :id_sub_unit) }
                   .sort_by { |pk| pk.values_at(:kode_giat, :id_sub_unit) }
  end

  def subkegiatans_renstra
    ProgramKegiatan.where(kode_opd: kode_opd)
                   .where.not(kode_skpd: [nil, ""])
                   .uniq { |pk| pk.values_at(:kode_sub_giat, :id_sub_unit) }
                   .sort_by { |pk| pk.values_at(:kode_sub_giat, :id_sub_unit) }
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
    strategis.where(role: "eselon_4")
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

  def eselon_dua_opd
    users.with_role("eselon_2").first
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

  def find_sasaran_eselon3(sasaran_kinerja)
    strategi_eselon3
      .joins("INNER JOIN sasarans ON cast (sasarans.strategi_id as INT) = strategis.id")
      .where("sasarans.sasaran_kinerja ILIKE ?", "%#{sasaran_kinerja}%")
      .where.not(sasarans: { nip_asn: nil })
      .map(&:sasaran)
  end

  def find_sasaran_eselon4(sasaran_kinerja)
    strategi_eselon4
      .joins("INNER JOIN sasarans ON cast (sasarans.strategi_id as INT) = strategis.id")
      .where("sasarans.sasaran_kinerja ILIKE ?", "%#{sasaran_kinerja}%")
      .where.not(sasarans: { nip_asn: nil })
      .map(&:sasaran)
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
end
