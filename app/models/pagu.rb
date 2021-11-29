class Pagu < ApplicationRecord
  before_save :hitung_total

  belongs_to :sasaran


  def hitung_total
    self.total = self.volume * self.uang
  end
end
