# == Schema Information
#
# Table name: rincians
#
#  id                  :bigint           not null, primary key
#  data_terpilah       :string
#  lokasi_pelaksanaan  :string
#  penyebab_external   :string
#  penyebab_internal   :string
#  permasalahan_gender :string
#  permasalahan_umum   :string
#  resiko              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  sasaran_id          :bigint           not null
#
# Indexes
#
#  index_rincians_on_sasaran_id  (sasaran_id)
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#
class Rincian < ApplicationRecord
  belongs_to :sasaran
  has_many :kesenjangan

  validates :lokasi_pelaksanaan, presence: true

end
