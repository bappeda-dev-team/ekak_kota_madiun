# == Schema Information
#
# Table name: opds
#
#  id                 :bigint           not null, primary key
#  bidang_urusan      :string
#  id_daerah          :string
#  id_opd_skp         :integer
#  kode_bidang_urusan :string
#  kode_opd           :string
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
#  index_opds_on_kode_unik_opd  (kode_unik_opd) UNIQUE
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
  has_one :kepala, class_name: 'Kepala', foreign_key: :nik, primary_key: :nip_kepala

  # kotak usulan opd
  has_many :usulans, dependent: :destroy
  has_many :pohons, dependent: :destroy
  has_many :isu_strategis_opds, foreign_key: 'kode_opd', primary_key: 'kode_opd'
  has_many :strategis

  accepts_nested_attributes_for :indikator_sasarans, reject_if: :all_blank, allow_destroy: true

  scope :opd_resmi, -> { where.not(kode_unik_opd: nil) }

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

  def strategi_eselon3
    strategis.where(role: "eselon_3")
  end

  def strategi_eselon4
    strategis.where(role: "eselon_4")
  end

  def strategi_staff
    strategis.where(role: "staff")
  end

  def eselon_dua_opd
    users.with_role("eselon_2").first
  end
end
