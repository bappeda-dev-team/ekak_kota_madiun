# == Schema Information
#
# Table name: indikators
#
#  id                   :bigint           not null, primary key
#  definisi_operational :jsonb
#  indikator            :string
#  is_hidden            :boolean          default(FALSE), not null
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
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Indikator < ApplicationRecord
  has_many :targets, dependent: :destroy
  accepts_nested_attributes_for :targets, reject_if: :all_blank, allow_destroy: true

  has_many :realisasis, dependent: :destroy
  accepts_nested_attributes_for :realisasis, reject_if: :all_blank, allow_destroy: true

  has_many :target_nspks, lambda {
    where(jenis: 'NSPK')
  }, class_name: 'Target', dependent: :destroy, inverse_of: :indikator
  accepts_nested_attributes_for :target_nspks, reject_if: :all_blank, allow_destroy: true

  has_many :target_ikks, lambda {
    where(jenis: 'IKK-IKD')
  }, class_name: 'Target', dependent: :destroy, inverse_of: :indikator
  accepts_nested_attributes_for :target_ikks, reject_if: :all_blank, allow_destroy: true

  has_many :target_lainnyas, lambda {
    where(jenis: 'Lainnya')
  }, class_name: 'Target', dependent: :destroy, inverse_of: :indikator
  accepts_nested_attributes_for :target_lainnyas, reject_if: :all_blank, allow_destroy: true

  has_and_belongs_to_many :users

  belongs_to :opd, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd', optional: true

  store_accessor :definisi_operational, :rumus_perhitungan
  store_accessor :definisi_operational, :sumber_data

  scope :rpjp_makro, -> { where(jenis: 'RPJP', sub_jenis: 'Makro').order(id: :desc) }
  scope :rpjmd_makro, -> { where(jenis: 'RPJMD', sub_jenis: 'Makro').order(id: :desc) }
  scope :rkpd_makro, -> { where(jenis: 'RKPD', sub_jenis: 'Outcome') }
  scope :rb_outcome, -> { where(jenis: 'RB', sub_jenis: 'Outcome').order(id: :desc) }
  scope :rb_output, -> { where(jenis: 'RB', sub_jenis: 'Output').order(id: :desc) }
  scope :lppd_outcome, -> { where(jenis: 'LPPD', sub_jenis: 'Outcome').order(id: :desc) }
  scope :lppd_output, -> { where(jenis: 'LPPD', sub_jenis: 'Output').order(id: :desc) }
  scope :spm_outcome, -> { where(jenis: 'SPM', sub_jenis: 'Outcome').order(id: :desc) }
  scope :spm_output, -> { where(jenis: 'SPM', sub_jenis: 'Output').order(id: :desc) }
  scope :sdgs_outcome, -> { where(jenis: 'SDGS', sub_jenis: 'Outcome').order(id: :desc) }
  scope :sdgs_output, -> { where(jenis: 'SDGS', sub_jenis: 'Output').order(id: :desc) }
  scope :stunting_outcome, -> { where(jenis: 'Stunting', sub_jenis: 'Outcome').order(id: :desc) }
  scope :stunting_output, -> { where(jenis: 'Stunting', sub_jenis: 'Output').order(id: :desc) }
  scope :penanganan_tb_outcome, -> { where(jenis: 'PenangananTB', sub_jenis: 'Outcome').order(id: :desc) }
  scope :penanganan_tb_output, -> { where(jenis: 'PenangananTB', sub_jenis: 'Output').order(id: :desc) }

  scope :iku_opd, -> { where(jenis: 'IKU', sub_jenis: 'OPD').order(id: :desc) }
  scope :hidden, -> { where(is_hidden: true) }
  scope :shown, -> { where(is_hidden: false) }

  def to_s
    indikator
  end

  def target_satuan
    "#{target} #{satuan}"
  end

  def jenis_sub_jenis
    "#{jenis} - #{indikator} (#{sub_jenis})"
  end

  # child_indikator('Kegiatan') ->
  # 'Kegiatan' with kode '3.27.03.2.01'
  # will match ['3.27.03.2.01.0016', '3.27.03.2.01.02', '3.27.03.2.01.01']
  # group in same kode, than find it maximum version
  # version is for audit / tracking change
  # updated by 1 in each update
  def child_indikator(sub_jenis)
    childs = Indikator.where(jenis: 'Renstra',
                             sub_jenis: sub_jenis,
                             kode_opd: kode_opd,
                             tahun: tahun)
    childs.filter { |child| child.kode.include?(kode) }
          .group_by(&:kode)
          .map { |_k, v| v.max_by(&:version) }
  end

  # cek perbedaan method ini dengan realisasi
  def sum_pagu_renstra(sub_jenis:, subkegiatan_used: { "none" => 0 })
    childs = child_indikator(sub_jenis)
    bb = childs.to_h { |ch| [ch.kode, ch.pagu] }

    hash_total = subkegiatan_used.replace(bb)
    hash_total.values.inject(0) { |injection, pagu| injection + pagu.to_i }
  end

  # realisasi
  def sum_realisasi_pagu_renstra(sub_jenis:)
    child_indikator(sub_jenis).inject(0) { |injection, pagu| injection + pagu.realisasi_pagu.to_i }
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

  def target_iku_opd
    targets.where(jenis: 'IKU_OPD')
  end

  def target_by_periode(tahun_awal, tahun_akhir)
    targets.by_periode(tahun_awal, tahun_akhir)
  end

  def target_tahun(tahun)
    targets.where(tahun: tahun).first
  end
end
