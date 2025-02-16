# == Schema Information
#
# Table name: misis
#
#  id          :bigint           not null, primary key
#  keterangan  :string
#  misi        :string
#  tahun_akhir :string
#  tahun_awal  :string
#  urutan      :integer          default(1)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  lembaga_id  :bigint           not null
#  visi_id     :bigint           not null
#
# Indexes
#
#  index_misis_on_lembaga_id  (lembaga_id)
#  index_misis_on_visi_id     (visi_id)
#
# Foreign Keys
#
#  fk_rails_...  (lembaga_id => lembagas.id)
#  fk_rails_...  (visi_id => visis.id)
#
class Misi < ApplicationRecord
  belongs_to :visi
  belongs_to :lembaga

  validates :misi, presence: true, length: { minimum: 5 }
  validates :urutan, numericality: { only_integer: true }
  validates :tahun_awal, presence: true, length: { is: 4 }
  validates :tahun_akhir, presence: true, length: { is: 4 }

  def to_s
    misi
  end

  def periode
    "#{tahun_awal}-#{tahun_akhir}"
  end
end
