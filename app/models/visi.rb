# == Schema Information
#
# Table name: visis
#
#  id          :bigint           not null, primary key
#  keterangan  :string
#  tahun_akhir :string
#  tahun_awal  :string
#  urutan      :integer          default(1)
#  visi        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  lembaga_id  :bigint           not null
#
# Indexes
#
#  index_visis_on_lembaga_id  (lembaga_id)
#
# Foreign Keys
#
#  fk_rails_...  (lembaga_id => lembagas.id)
#
class Visi < ApplicationRecord
  has_many :misis
  belongs_to :lembaga

  validates :visi, presence: true, length: { minimum: 5 }
  validates :urutan, numericality: { only_integer: true }
  validates :tahun_awal, presence: true, length: { is: 4 }
  validates :tahun_akhir, presence: true, length: { is: 4 }

  scope :by_periode, lambda { |tahun|
                       where("tahun_awal::integer <= ?::integer", tahun)
                         .where("tahun_akhir::integer >= ?::integer", tahun)
                     }

  def to_s
    visi
  end

  def visi_with_urutan_and_lembaga
    "#{urutan}. #{visi} - #{lembaga}"
  end

  def periode
    "#{tahun_awal}-#{tahun_akhir}"
  end
end
