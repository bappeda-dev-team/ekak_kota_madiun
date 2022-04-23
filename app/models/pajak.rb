# == Schema Information
#
# Table name: pajaks
#
#  id         :bigint           not null, primary key
#  tahun      :string
#  tipe       :string
#  potongan   :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Pajak < ApplicationRecord
  has_many :anggarans
  has_many :perhitungans
  validates :tipe, presence: true
  validates :potongan, presence: true, numericality: true

  def simple_pajak
    "#{Integer potongan * 100}%"
  end
end
