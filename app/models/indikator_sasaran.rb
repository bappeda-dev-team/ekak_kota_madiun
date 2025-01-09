# == Schema Information
#
# Table name: indikator_sasarans
#
#  id                :bigint           not null, primary key
#  aspek             :string
#  id_indikator      :string
#  indikator_kinerja :string
#  is_hidden         :boolean          default(FALSE), not null
#  keterangan        :string
#  satuan            :string
#  target            :string
#  type              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  sasaran_id        :string
#
# Indexes
#
#  index_indikator_sasarans_on_id_indikator  (id_indikator) UNIQUE
#
class IndikatorSasaran < ApplicationRecord
  belongs_to :sasaran, primary_key: 'id_rencana', optional: true
  has_one :manual_ik, dependent: :destroy

  validates :indikator_kinerja, presence: true
  validates :target, presence: true
  validates :satuan, presence: true

  delegate :tahun, to: :sasaran

  def to_s
    indikator_kinerja
  end

  def indikator_tahun
    "#{indikator_kinerja} - #{tahun}"
  end

  def sasaran_kabid
    Sasaran.where(sasaran_atasan_id: id_indikator)
  end

  def target_dan_satuan
    "#{target} #{satuan}"
  end

  def target_satuan
    "#{target} #{satuan}"
  end

  def indikator
    indikator_kinerja
  end

  def sumber_data
    manual_ik.sumber_data
  rescue StandardError
    ''
  end

  def rumus_perhitungan
    manual_ik.formula
  rescue StandardError
    ''
  end

  def output_data
    manual_ik.output_data
  rescue StandardError
    []
  end
end
