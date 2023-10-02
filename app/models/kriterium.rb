# == Schema Information
#
# Table name: kriteria
#
#  id            :bigint           not null, primary key
#  keterangan    :string
#  kriteria      :string
#  poin_max      :integer
#  poin_min      :integer
#  tipe_kriteria :string
#  type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  kriteria_id   :bigint
#
class Kriterium < ApplicationRecord
  TIPE_KRITERIA_OPTIONS = %w[SasaranKinerja Tahapan RincianBelanja].freeze

  validates :kriteria, presence: true
  validates :poin_max, presence: true
  validates :poin_min, presence: true
  validates :tipe_kriteria, presence: true

  has_many :sub_kriteria, primary_key: :id, foreign_key: :kriteria_id

  def to_s
    kriteria
  end
end
