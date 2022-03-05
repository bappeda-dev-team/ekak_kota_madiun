# == Schema Information
#
# Table name: pagus
#
#  id         :bigint           not null, primary key
#  item       :string
#  satuan     :string
#  tipe       :string
#  total      :integer
#  uang       :integer
#  volume     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sasaran_id :bigint           not null
#
# Indexes
#
#  index_pagus_on_sasaran_id  (sasaran_id)
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#
class Pagu < ApplicationRecord
  before_save :hitung_total
  before_update :hitung_total
  after_save :update_anggaran
  after_update :update_anggaran
  after_destroy :update_anggaran

  belongs_to :sasaran

  validates :item, presence: true

  def hitung_total
    self.total = volume * uang
  end

  def update_anggaran
    sasaran = self.sasaran
    sasaran.anggaran = total
    sasaran.save
  end
end
