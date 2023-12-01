# == Schema Information
#
# Table name: manual_iks
#
#  id                   :bigint           not null, primary key
#  akhir                :string
#  budget               :string
#  definisi             :string
#  formula              :string
#  indikator_kinerja    :string
#  jenis_indikator      :string
#  key_activities       :string
#  key_milestone        :string
#  mulai                :string
#  output_data          :string           default(["\"kinerja\""]), is an Array
#  penanggung_jawab     :string
#  penyedia_data        :string
#  periode_pelaporan    :string
#  perspektif           :string
#  rhk                  :string
#  satuan               :string
#  sumber_data          :string
#  target               :string
#  tujuan_rhk           :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  indikator_sasaran_id :string
#
class ManualIk < ApplicationRecord
  belongs_to :indikator_sasaran

  # serialize :output_data, Array

  validates :perspektif, presence: true
  validates :rhk, presence: true
  validates :tujuan_rhk, presence: true
  validates :indikator_kinerja, presence: true
  validates :target, presence: true
  validates :satuan, presence: true
  validates :definisi, presence: true
  validates :key_activities, presence: true
  validates :formula, presence: true
  validates :jenis_indikator, presence: true
  validates :penanggung_jawab, presence: true
  validates :penyedia_data, presence: true
  validates :sumber_data, presence: true

  PERSPEKTIF = [
    'Penerima Layanan',
    'Proses Bisnis',
    'Penguatan Internal',
    'Anggaran'
  ].freeze

  JENIS_INDIKATOR = %w[
    Outcome
    Output
  ].freeze

  PERIODE_PELAPORAN = %w[
    Bulanan
    Triwulan
    Tahunan
  ].freeze

  OUTPUT_DATA = %w[
    kinerja
    penduduk
    spatial
  ].freeze
end
