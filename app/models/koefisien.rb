# == Schema Information
#
# Table name: koefisiens
#
#  id             :bigint           not null, primary key
#  satuan_volume  :string
#  volume         :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  perhitungan_id :bigint
#
# Indexes
#
#  index_koefisiens_on_perhitungan_id  (perhitungan_id)
#
class Koefisien < ApplicationRecord
  belongs_to :perhitungan
  validates :volume, presence: true
end
