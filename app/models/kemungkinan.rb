# == Schema Information
#
# Table name: skalas
#
#  id         :bigint           not null, primary key
#  deskripsi  :string
#  keterangan :string
#  kode_skala :string
#  nilai      :string
#  tipe_nilai :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rincian_id :bigint
#
class Kemungkinan < Skala
  validates :kode_skala, presence: true
  has_one :rincian

  scope :pilihan, -> { all.order('nilai ASC') }
end
