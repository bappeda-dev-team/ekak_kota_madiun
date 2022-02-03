# == Schema Information
#
# Table name: pagus
#
#  id         :bigint           not null, primary key
#  item       :string
#  uang       :integer
#  tipe       :string
#  satuan     :string
#  volume     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sasaran_id :bigint           not null
#  total      :integer
#
class Pagu < ApplicationRecord
  before_save :hitung_total
  before_update :hitung_total
  after_save :update_anggaran
  after_update :update_anggaran
  after_destroy :update_anggaran

  belongs_to :sasaran


  def hitung_total
    self.total = self.volume * self.uang
  end

  def update_anggaran
    sasaran = self.sasaran
    sasaran.anggaran = self.total
    sasaran.save
  end

end
