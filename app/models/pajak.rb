class Pajak < ApplicationRecord
  has_many :anggarans

  def simple_pajak
    String(Integer self.potongan * 100) + "%"
  end
end
