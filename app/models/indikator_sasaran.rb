# == Schema Information
#
# Table name: indikator_sasarans
#
#  id                :bigint           not null, primary key
#  aspek             :string
#  id_indikator      :string
#  indikator_kinerja :string
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
  belongs_to :sasaran, foreign_key: 'sasaran_id', primary_key: 'id_rencana', optional: true
  has_one :manual_ik

  amoeba do
    append sasaran_id: '_2022_p'
    append id_indikator: '_2022_p'
  end

  def sasaran_kabid
    Sasaran.where(sasaran_atasan_id: id_indikator)
  end

  def target_dan_satuan
    "#{target} #{satuan}"
  end
end
