# == Schema Information
#
# Table name: rincians
#
#  id                  :bigint           not null, primary key
#  dampak              :string
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
  include Skalable

  has_many :kesenjangans
  belongs_to :sasaran, optional: true
  # validates :lokasi_pelaksanaan, presence: true

  def lengkap
    data_terpilah.exists? && lokasi_pelaksanaan.exists?
  end
end
