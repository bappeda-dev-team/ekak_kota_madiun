class Anggaran < ApplicationRecord
  belongs_to :tahapan
  has_many :perhitungans
  # child untuk memanggil id isian bawahnya
  has_many :childs, :class_name => 'Anggaran', :foreign_key => 'parent_id'
  belongs_to :parent, class_name: "Anggaran", optional: true
  belongs_to :pajak

  scope :tanpa_pajak, -> { where(pajak_id: nil) }
  scope :root_anggaran, -> { where(level: 0) }
end
