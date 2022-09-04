# == Schema Information
#
# Table name: program_kegiatans
#
#  id                        :bigint           not null, primary key
#  id_giat                   :string
#  id_program_sipd           :string
#  id_sub_giat               :string
#  id_sub_unit               :string
#  id_unit                   :string
#  identifier_belanja        :string
#  indikator_kinerja         :string
#  indikator_program         :string
#  indikator_subkegiatan     :string
#  isu_strategis             :string
#  kode_bidang_urusan        :string
#  kode_giat                 :string
#  kode_opd                  :string
#  kode_program              :string
#  kode_skpd                 :string
#  kode_sub_giat             :string
#  kode_sub_skpd             :string
#  kode_urusan               :string
#  nama_bidang_urusan        :string
#  nama_kegiatan             :string
#  nama_program              :string
#  nama_subkegiatan          :string
#  nama_urusan               :string
#  pagu                      :string
#  satuan                    :string
#  satuan_target_program     :string
#  satuan_target_subkegiatan :string
#  tahun                     :string
#  target                    :string
#  target_program            :string
#  target_subkegiatan        :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  subkegiatan_tematik_id    :bigint
#
# Indexes
#
#  index_program_kegiatans_on_identifier_belanja      (identifier_belanja) UNIQUE
#  index_program_kegiatans_on_subkegiatan_tematik_id  (subkegiatan_tematik_id)
#
# Foreign Keys
#
#  fk_rails_...  (subkegiatan_tematik_id => subkegiatan_tematiks.id)
#
class ProgramKegiatan < ApplicationRecord
  validates :nama_program, presence: true
  validates :kode_program, presence: true
  belongs_to :opd, foreign_key: 'kode_opd', primary_key: 'kode_opd'
  has_many :kaks
  has_many :sasarans, dependent: :nullify
  has_many :usulans, through: :sasarans
  has_many :subkegiatan_tematiks, through: :sasarans
  has_many :rincians, through: :sasarans
  has_many :permasalahans, through: :sasarans
  has_many :users, through: :sasarans
  has_many :kegiatans, class_name: 'ProgramKegiatan', foreign_key: 'kode_program', primary_key: 'kode_program'
  has_many :subkegiatans, class_name: 'ProgramKegiatan', foreign_key: 'kode_giat', primary_key: 'kode_giat'
  has_many :indikator_program_renstra, lambda {
                                         where(jenis: 'Renstra', sub_jenis: 'Program')
                                       }, class_name: 'Indikator', foreign_key: 'kode', primary_key: 'kode_program'
  has_many :indikator_kegiatan_renstra, lambda {
                                          where(jenis: 'Renstra', sub_jenis: 'Kegiatan')
                                        }, class_name: 'Indikator', foreign_key: 'kode', primary_key: 'kode_giat'
  has_many :indikator_subkegiatan_renstra, lambda {
                                             where(jenis: 'Renstra', sub_jenis: 'Subkegiatan')
                                           }, class_name: 'Indikator', foreign_key: 'kode', primary_key: 'kode_sub_giat'

  scope :with_sasarans, -> { where(id: Sasaran.pluck(:program_kegiatan_id)) }

  scope :programs, -> { select("DISTINCT ON(program_kegiatans.kode_program) program_kegiatans.*") }
  scope :kegiatans_satunya, -> { select("DISTINCT ON(program_kegiatans.kode_giat) program_kegiatans.*") }
  scope :subkegiatans_satunya, -> { select("DISTINCT ON(program_kegiatans.kode_sub_giat) program_kegiatans.*") }
  def kegiatans
    super.uniq(&:kode_giat)
  end

  def my_pagu
    sasarans.sudah_lengkap.map(&:total_anggaran).compact.sum
  end

  def my_waktu
    sasarans.map(&:waktu_total).compact.sum
  end

  def indikator_renstras
    program = indikator_program_renstra.group_by(&:indikator).transform_values do |indikator|
      indikator.group_by(&:tahun)
    end
    kegiatan = indikator_kegiatan_renstra.group_by(&:indikator).transform_values do |indikator|
      indikator.group_by(&:tahun)
    end
    subkegiatan = indikator_subkegiatan_renstra.group_by(&:indikator).transform_values do |indikator|
      indikator.group_by(&:tahun)
    end
    {
      indikator_program: program.to_h,
      indikator_kegiatan: kegiatan.to_h,
      indikator_subkegiatan: subkegiatan.to_h
    }
  end

  def target_program_tahun(tahun:)
    indikator_program_renstra.where(tahun: tahun)
                             .pluck(:target,
                                    :satuan,
                                    :pagu).each_with_object({}) do |(target, satuan, pagu), result|
      result[:target] = target
      result[:satuan] = satuan
      result[:pagu] = pagu
    end
  end

  def target_program_renstra
    indikator_program_renstra.pluck(
      :indikator,
      :target,
      :satuan,
      :pagu,
      :tahun
    ).each_with_object({}) do |(indikator, target, satuan, pagu, tahun), result|
      result[tahun] = {
        indikator: indikator,
        target: target,
        satuan: satuan,
        pagu: pagu
      }
    end
  end

  def target_kegiatan_tahun(tahun:)
    indikator_kegiatan_renstra.where(tahun: tahun)
                              .pluck(:target,
                                     :satuan,
                                     :pagu).each_with_object({}) do |(target, satuan, pagu), result|
      result[:target] = target
      result[:satuan] = satuan
      result[:pagu] = pagu
    end
  end

  def target_kegiatan_renstra
    indikator_kegiatan_renstra.pluck(:target,
                                     :satuan,
                                     :pagu,
                                     :tahun).each_with_object({}) do |(target, satuan, pagu, tahun), result|
      result[tahun] = {
        target: target,
        satuan: satuan,
        pagu: pagu
      }
    end
  end

  def target_subkegiatan_tahun(tahun:)
    indikator_subkegiatan_renstra.where(tahun: tahun)
                                 .pluck(:target,
                                        :satuan,
                                        :pagu).each_with_object({}) do |(target, satuan, pagu), result|
      result[:target] = target
      result[:satuan] = satuan
      result[:pagu] = pagu
    end
  end

  def target_subkegiatan_renstra
    indikator_subkegiatan_renstra.pluck(:target,
                                        :satuan,
                                        :pagu,
                                        :tahun).each_with_object({}) do |(target, satuan, pagu, tahun), result|
      result[tahun] = {
        target: target,
        satuan: satuan,
        pagu: pagu
      }
    end
  end

  def pagu_sub_tahun(tahun:, kode_sub_giat:)
    ProgramKegiatan.find_by(kode_sub_giat: kode_sub_giat, tahun: tahun)&.pagu || 0
  end

  def nama_opd_pemilik
    id_sub_unit.nil? ? '-' : Opd.find_by(id_opd_skp: id_sub_unit).nama_opd
  end

  def count_indikator_sasarans(tahun:)
    sasarans.where(tahun: tahun).map { |s| s.indikator_sasarans.count }.inject(:+)
  end

  def all_anggaran
    sasarans.map(&:total_anggaran).compact.sum
  end

  def jumlah_sasaran
    sasarans.where(tahun: %w[2022 2023 2024]).size
  end
end
