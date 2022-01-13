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

  def the_parent
    parents = []
    unless self.parent.nil?
      parents << self.parent
      parents.concat(self.parent.the_parent)
    end
    return parents
  end

  def grand_parent
    the_parent.last
  end

end
