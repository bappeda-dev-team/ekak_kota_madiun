class Anggaran < ApplicationRecord
  belongs_to :tahapan
  has_many :perhitungans
  # child untuk memanggil id isian bawahnya
  has_many :childs, :class_name => 'Anggaran', :foreign_key => 'parent_id'
  belongs_to :parent, class_name: "Anggaran", optional: true

end
