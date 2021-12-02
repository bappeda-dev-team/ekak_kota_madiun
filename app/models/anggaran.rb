class Anggaran < ApplicationRecord
  belongs_to :tahapan
  has_many :perhitungans
  # child untuk memanggil id isian bawahnya
  has_many :childs, :class_name => 'Anggaran', :foreign_key => 'parent_id'
  belongs_to :parent, class_name: "Anggaran", optional: true
  belongs_to :pajak

  scope :tanpa_pajak, -> { where(pajak_id: nil) }
  scope :ujung_anggaran, -> { where(level: 0) }
  scope :pangkal_anggaran, -> { where(level: 5)}

  # get all anggaran with koefisiens
  def with_koefisiens
    self.perhitungans.includes(:koefisiens).map(&:koefisiens)
  end
end
