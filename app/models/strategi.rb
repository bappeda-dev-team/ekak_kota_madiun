# == Schema Information
#
# Table name: strategis
#
#  id                    :bigint           not null, primary key
#  linked_with           :bigint
#  metadata              :jsonb
#  nip_asn               :string
#  nip_asn_sebelumnya    :string
#  role                  :string
#  strategi              :string
#  strategi_cascade_link :bigint
#  tahun                 :string
#  type                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  opd_id                :string
#  pohon_id              :bigint
#  sasaran_id            :string
#  strategi_ref_id       :string
#  tujuan_id             :bigint
#
# Indexes
#
#  index_strategis_on_pohon_id  (pohon_id)
#
class Strategi < ApplicationRecord
  default_scope { order(:id) }
  # belongs_to :pohon, optional: true
  belongs_to :opd, optional: true
  belongs_to :tujuan, optional: true
  belongs_to :user, foreign_key: 'nip_asn', primary_key: 'nik', optional: true
  has_many :sasarans
  # has_many :pohons, as: :pohonable
  has_one :pohon, as: :pohonable
  has_many :reviews, as: :reviewable
  # has_many :komentars, primary_key: :id, foreign_key: :item

  # has_many :indikator_sasarans, through: :sasarans
  has_many :indikators, lambda {
                          where(jenis: 'Strategi', sub_jenis: 'StrategiPohon')
                        }, class_name: 'Indikator', foreign_key: 'kode', primary_key: 'id'

  accepts_nested_attributes_for :indikators, reject_if: :all_blank, allow_destroy: true

  has_many :strategi_bawahans, class_name: 'Strategi',
                               primary_key: :id, foreign_key: :strategi_ref_id

  belongs_to :strategi_atasan, class_name: "Strategi",
                               foreign_key: "strategi_ref_id", optional: true
  belongs_to :strategi_pokin, class_name: "StrategiPohon",
                              foreign_key: 'linked_with', optional: true

  store :metadata, accessors: %w[keterangan updated_by updated_at deleted_at deleted_by prev_role]

  def to_s
    strategi
  end

  def strategi_asn
    linked_with.present? ? Strategi.find(linked_with).strategi : strategi
  end

  def milik_non_kepala
    role != 'eselon_2'
  end

  def isu_strategis_disasar
    if strategi_atasan.nil?
      pohon.keterangan
    else
      "#{strategi_atasan.strategi} - #{strategi_atasan.user&.nama} - #{strategi_atasan&.tahun}"
    end
  end

  # def strategi_bawahans
  #   strategi_hasil = if role == 'eselon_2' && opd_id == '145'
  #                      strategi_eselon_dua_bs
  #                    elsif role == 'eselon_2' || (role == 'eselon_2b' && opd_id == '145')
  #                      strategi_eselon_tigas
  #                    elsif role == 'eselon_3'
  #                      strategi_eselon_empats
  #                    else
  #                      strategi_staffs
  #                    end
  #   strategi_hasil.where.not(nip_asn: "")
  # end

  def strategi_dan_nip
    strategi.nil? ? "dibagikan ke #{nip_asn}" : "#{user&.nama} - #{strategi} - Indikator #{indikators.pluck(:indikator_kinerja)}"
  end

  # def indikators
  #   indikator_sasarans.compact_blank
  # end

  # def indikator_strategi
  #   indikator_sasarans.pluck(:indikator_kinerja)
  # end

  # def target_satuan_strategi
  #   indikator_sasarans.pluck(:target, :satuan)
  # end

  # def indikator
  #   indikator_sasarans.first.indikator_kinerja
  # end

  # def target
  #   indikator_sasarans.first.target
  # end

  # def satuan
  #   indikator_sasarans.first.satuan
  # end

  def nama
    user&.nama
  end

  def nama_pemilik
    "#{nama} (#{nip_pemilik})"
  rescue StandardError
    "Kosong"
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

  # def tactical_2b_objectives
  #   strategi_eselon_dua_bs.includes(:indikator_sasarans).where.not(strategi: "")
  # end

  # def tactical_objectives
  #   strategi_eselon_tigas.includes(:indikator_sasarans).where.not(strategi: "")
  # end

  # def operational_objectives
  #   strategi_eselon_empats.includes(:indikator_sasarans).where.not(strategi: "")
  # end

  # def operational_2_objectives
  #   strategi_staffs.includes(:indikator_sasarans).where.not(strategi: "")
  # end

  def program_kegiatan_strategi
    sasaran&.program_kegiatan
  end

  def indikator_subkegiatan_strategi(_tahun, kode_opd)
    sasaran.program_kegiatan.indikator_renstras_new('subekegiatan', kode_opd)
    # rescue NoMethodError
    #   { indikator_subkegiatan: {} }
  end

  def programs_strategi
    operational_objectives.map(&:program_kegiatan_strategi).group_by(&:nama_program)
  rescue NoMethodError
    { Kosong: [] }
  end

  def kegiatan_strategi
    sasaran.program_kegiatan.nama_kegiatan
  rescue NoMethodError
    'Kosong'
  end

  def subkegiatan_strategi
    sasaran.program_kegiatan.nama_subkegiatan
  rescue NoMethodError
    'Kosong'
  end

  def subkegiatans_sasarans
    operational_objectives.map(&:sasaran).group_by(&:program_kegiatan)
  end

  def sasaran_strategi
    operational_objectives.map(&:sasaran)
  end

  def rekap_program_opd
    tactical_objectives.map { |aa| aa.programs_strategi.keys }.flatten
  end

  def renaksi
    sasaran.tahapans.pluck(:tahapan_kerja)
  end

  def tahun_asli
    tahun.match(/murni/) ? tahun[/[^_]\d*/, 0] : tahun
  rescue NoMethodError
    nil
  end

  def transfered?
    StrategiPohon.find_by(strategi_cascade_link: id).nil?
  end

  def sasaran_kinerja
    sasaran.sasaran_kinerja
  rescue StandardError
    'Kosong'
  end

  def tahun_sasaran
    sasaran.tahun
  rescue StandardError
    '-'
  end

  def strategi_atasnya
    strategi_atasan.strategi
  rescue StandardError
    'Tidak ada strategi atasan'
  end

  def pemilik_strategi_atasnya
    strategi_atasan.nama_pemilik
  rescue StandardError
    'Tidak ada pemilik'
  end

  def create_new_pohon(**args)
    return unless pohon.nil?

    attributes = {
      **args,
      pohonable_id: id,
      pohonable_type: 'Strategi',
      opd_id: opd_id,
      tahun: tahun
    }
    create_pohon!(attributes)
  end

  def id_strategi
    "#{id}-#{role}"
  end

  def judul_strategi
    "#{strategi} #{'- Kota' if role.include?('kota')}"
  end

  def id_strategi_parent
    if pohon.nil?
      "#{strategi_ref_id}-#{strategi_atasan&.role}"
    else
      pohon.id_strategi_parent
    end
  end
end
