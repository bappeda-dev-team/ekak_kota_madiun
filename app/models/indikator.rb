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
#  satuan               :string
#  sub_jenis            :string
#  tahun                :string
#  target               :string
#  version              :integer          default(0), not null
#
class Indikator < ApplicationRecord
  has_many :targets
  belongs_to :opd, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd'
  accepts_nested_attributes_for :targets, reject_if: :all_blank, allow_destroy: true

  store_accessor :definisi_operational, :rumus_perhitungan
  store_accessor :definisi_operational, :sumber_data

  scope :rkpd_makro, -> { where(jenis: 'RKPD', sub_jenis: 'Outcome') }

  def to_s
    indikator
  end

  def target_satuan
    "#{target} #{satuan}"
  end
end
