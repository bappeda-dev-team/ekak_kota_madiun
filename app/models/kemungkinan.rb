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
# Indexes
#
#  index_skalas_on_rincian_id  (rincian_id)
#
class Kemungkinan < Skala
  validates :kode_skala, presence: true
end
