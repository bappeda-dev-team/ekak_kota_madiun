class Sasaran < ApplicationRecord
  belongs_to :user
  has_one :rincian
  has_many :pagus
  belongs_to :program_kegiatan, optional: true
  before_save :sum_anggaran
  before_update :sum_anggaran

  def sum_anggaran
    if self.pagus.any?
      self.anggaran = self.pagus.sum(:total)
    else
      self.anggaran = 0
    end
  end
end
