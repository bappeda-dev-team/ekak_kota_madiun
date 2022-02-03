# == Schema Information
#
# Table name: koefisiens
#
#  id             :bigint           not null, primary key
#  volume         :integer
#  satuan_volume  :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  perhitungan_id :bigint
#
class Koefisien < ApplicationRecord
  belongs_to :perhitungan
end
