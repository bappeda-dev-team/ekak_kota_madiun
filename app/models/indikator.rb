# == Schema Information
#
# Table name: indikators
#
#  id                   :bigint           not null, primary key
#  definisi_operational :jsonb
#  indikator            :string
#  jenis                :string
#  keterangan           :string
#  kode                 :string
#  kode_indikator       :string
#  kode_opd             :string
#  kotak                :integer          default(0), not null
#  pagu                 :string           default("0")
#  realisasi            :string
#  realisasi_pagu       :string
#  satuan               :string
#  sub_jenis            :string
#  tahun                :string
#  target               :string
#  version              :integer          default(0), not null
#
class Indikator < ApplicationRecord
  has_many :targets
  accepts_nested_attributes_for :targets, reject_if: :all_blank, allow_destroy: true

  has_and_belongs_to_many :users

  belongs_to :opd, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd', optional: true

  store_accessor :definisi_operational, :rumus_perhitungan
  store_accessor :definisi_operational, :sumber_data

  scope :rkpd_makro, -> { where(jenis: 'RKPD', sub_jenis: 'Outcome') }
  scope :rb_outcome, -> { where(jenis: 'RB', sub_jenis: 'Outcome').order(id: :desc) }
  scope :rb_output, -> { where(jenis: 'RB', sub_jenis: 'Output').order(id: :desc) }
  scope :lppd_outcome, -> { where(jenis: 'LPPD', sub_jenis: 'Outcome').order(id: :desc) }
  scope :lppd_output, -> { where(jenis: 'LPPD', sub_jenis: 'Output').order(id: :desc) }
  scope :spm_outcome, -> { where(jenis: 'SPM', sub_jenis: 'Outcome').order(id: :desc) }
  scope :spm_output, -> { where(jenis: 'SPM', sub_jenis: 'Output').order(id: :desc) }
  scope :sdgs_outcome, -> { where(jenis: 'SDGS', sub_jenis: 'Outcome').order(id: :desc) }
  scope :sdgs_output, -> { where(jenis: 'SDGS', sub_jenis: 'Output').order(id: :desc) }

  def to_s
    indikator
  end

  def target_satuan
    "#{target} #{satuan}"
  end

  def jenis_sub_jenis
    "#{jenis} - #{indikator} (#{sub_jenis})"
  end

  def sum_pagu_renstra(sub_jenis:)
    indikator_childs = Indikator.where(jenis: 'Renstra',
                                       sub_jenis: sub_jenis,
                                       kode_opd: kode_opd,
                                       tahun: tahun).filter do |child|
      child.kode.include?(kode)
    end
    pagu_sub = indikator_childs.group_by(&:kode)
                               .map { |_k, v| v.max_by(&:version) }
    pagu_sub.inject(0) { |injection, pagu| injection + pagu.pagu.to_i }
  end

  def sum_realisasi_pagu_renstra(sub_jenis:)
    indikator_childs = Indikator.where(jenis: 'Renstra',
                                       sub_jenis: sub_jenis,
                                       kode_opd: kode_opd,
                                       tahun: tahun).filter do |child|
      child.kode.include?(kode)
    end
    pagu_sub = indikator_childs.group_by(&:kode)
                               .map { |_k, v| v.max_by(&:version) }
    pagu_sub.inject(0) { |injection, pagu| injection + pagu.realisasi_pagu.to_i }
  end

  def capaian_pagu
    capaian = if realisasi_pagu != 0 && pagu != 0
                ((realisasi_pagu / pagu.to_f) * 100)
              else
                0.0
              end
    capaian.nan? ? 0.0 : capaian.round(2)
  rescue NoMethodError
    0.0
  end

  def sum_capaian_pagu(sub_jenis:)
    sum_pagu = sum_pagu_renstra(sub_jenis: sub_jenis)
    sum_realisasi = sum_realisasi_pagu_renstra(sub_jenis: sub_jenis)
    capaian = if sum_realisasi != 0 && sum_pagu != 0
                ((sum_realisasi / sum_pagu.to_f) * 100).round(2)
              else
                0.0
              end
    capaian.nan? ? 0.0 : capaian.round(2)
  rescue NoMethodError
    0.0
  end

  def capaian_target
    capaian = if target != 0 && realisasi != 0
                ((realisasi / target.to_f) * 100)
              else
                0.0
              end
    capaian.nan? ? 0.0 : capaian.round(2)
  rescue NoMethodError
    0.0
  end

  def kode_urusan
    kode[0]
  end

  def kode_bidang_urusan
    kode[0, 4]
  end
end
