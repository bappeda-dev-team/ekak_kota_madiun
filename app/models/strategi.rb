# == Schema Information
#
# Table name: strategis
#
#  id                 :bigint           not null, primary key
#  nip_asn            :string
#  nip_asn_sebelumnya :string
#  role               :string
#  strategi           :string
#  tahun              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  opd_id             :string
#  pohon_id           :bigint
#  sasaran_id         :string
#  strategi_ref_id    :string
#
# Indexes
#
#  index_strategis_on_pohon_id  (pohon_id)
#
class Strategi < ApplicationRecord
  default_scope { order(:id) }
  belongs_to :pohon, optional: true
  belongs_to :opd, optional: true
  belongs_to :user, foreign_key: 'nip_asn', primary_key: 'nik', optional: true
  has_one :sasaran
  accepts_nested_attributes_for :sasaran, update_only: true

  has_many :indikator_sasarans, through: :sasaran

  belongs_to :strategi_atasan, class_name: "Strategi",
                               foreign_key: "strategi_ref_id", optional: true

  belongs_to :strategi_eselon_dua, lambda {
    where(role: "eselon_2")
  }, class_name: "Strategi",
     foreign_key: "strategi_ref_id", optional: true

  has_many :strategi_eselon_dua_bs, lambda {
    where(role: "eselon_2b").where.not(nip_asn: "")
  }, class_name: "Strategi",
     foreign_key: "strategi_ref_id", dependent: :destroy

  has_many :strategi_eselon_tiga_setda, lambda {
    where(role: "eselon_3").where.not(nip_asn: "")
  }, class_name: "Strategi",
     foreign_key: "strategi_ref_id", dependent: :destroy

  has_many :strategi_eselon_tigas, lambda {
    where(role: "eselon_3").or(where(role: "eselon_2b")).where.not(nip_asn: "")
  }, class_name: "Strategi",
     foreign_key: "strategi_ref_id", dependent: :destroy

  has_many :strategi_eselon_empats, lambda {
    where(role: "eselon_4").where.not(nip_asn: "")
  }, class_name: "Strategi",
     foreign_key: "strategi_ref_id", dependent: :destroy

  has_many :strategi_staffs, lambda {
    where(role: "staff").where.not(nip_asn: "")
  }, class_name: "Strategi",
     foreign_key: "strategi_ref_id", dependent: :destroy

  amoeba do
    set tahun: '2022_p'
    include_association %i[strategi_eselon_dua_bs strategi_eselon_tigas strategi_eselon_empats strategi_staffs]
  end

  def isu_strategis_disasar
    strategi_atasan.nil? ? pohon.keterangan : "#{strategi_atasan.strategi} - #{strategi_atasan.user&.nama}"
  end

  def strategi_bawahans
    strategi_hasil = if role == 'eselon_2' && opd_id == '145'
                       strategi_eselon_dua_bs
                     elsif role == 'eselon_2' || (role == 'eselon_2b' && opd_id == '145')
                       strategi_eselon_tigas
                     elsif role == 'eselon_3'
                       strategi_eselon_empats
                     else
                       strategi_staffs
                     end
    strategi_hasil.where.not(nip_asn: "")
  end

  def strategi_dan_nip
    strategi.nil? ? "dibagikan ke #{nip_asn}" : "#{user&.nama} - #{strategi} - Indikator #{indikator_sasarans.pluck(:indikator_kinerja)}"
  end

  def indikators
    indikator_sasarans.compact_blank
  end

  def indikator_strategi
    indikator_sasarans.pluck(:indikator_kinerja)
  end

  def target_satuan_strategi
    indikator_sasarans.pluck(:target, :satuan)
  end

  def nama_pemilik
    user&.nama
  end

  def nip_pemilik
    user&.nik
  end

  def jabatan_pemilik
    user&.jabatan
  end

  def strategis
    self
  end

  def tactical_2b_objectives
    strategi_eselon_dua_bs.includes(:indikator_sasarans).where.not(strategi: "")
  end

  def tactical_objectives
    strategi_eselon_tigas.includes(:indikator_sasarans).where.not(strategi: "")
  end

  def operational_objectives
    strategi_eselon_empats.includes(:indikator_sasarans).where.not(strategi: "")
  end

  def operational_2_objectives
    strategi_staffs.includes(:indikator_sasarans).where.not(strategi: "")
  end

  def program_kegiatan_strategi
    sasaran&.program_kegiatan
  end

  def indikator_subkegiatan_strategi(_tahun, kode_opd)
    sasaran.program_kegiatan.indikator_renstras_new('subekegiatan', kode_opd)
    # rescue NoMethodError
    #   { indikator_subkegiatan: {} }
  end

  def subkegiatan_strategi
    sasaran.program_kegiatan.nama_subkegiatan
  rescue NoMethodError
    'Kosong'
  end

  def programs_strategi
    operational_objectives.map(&:program_kegiatan_strategi).compact_blank.group_by(&:nama_program)
  rescue NoMethodError
    { Kosong: [] }
  end

  def rekap_program_opd
    tactical_objectives.map { |aa| aa.programs_strategi.keys }.flatten
  end

  def renaksi
    sasaran.tahapans.pluck(:tahapan_kerja)
  end
end
