# == Schema Information
#
# Table name: tahapans
#
#  id               :bigint           not null, primary key
#  bulan            :string
#  jumlah_realisasi :integer
#  jumlah_target    :integer
#  keterangan       :string
#  progress         :integer
#  realisasi        :integer
#  tahapan_kerja    :string
#  target           :integer
#  waktu            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  rincian_id       :bigint           not null
#
# Indexes
#
#  index_tahapans_on_rincian_id  (rincian_id)
#
# Foreign Keys
#
#  fk_rails_...  (rincian_id => rincians.id)
#
class Tahapan < ApplicationRecord
  belongs_to :rincian
  has_many :aksis , :dependent => :destroy
  has_many :anggarans, :dependent => :destroy
end
