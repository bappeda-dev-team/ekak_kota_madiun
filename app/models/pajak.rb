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

  def simple_pajak
    String(Integer self.potongan * 100) + "%"
  end
end
