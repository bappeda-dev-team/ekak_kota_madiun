# == Schema Information
#
# Table name: anggarans
#
#  id         :bigint           not null, primary key
#  jumlah     :integer
#  kode_rek   :string
#  level      :integer          default(0)
#  set_input  :string           default("0")
#  tahun      :integer
#  uraian     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pajak_id   :bigint
#  parent_id  :bigint
#  tahapan_id :bigint
#
# Indexes
#
#  index_anggarans_on_pajak_id    (pajak_id)
#  index_anggarans_on_parent_id   (parent_id)
#  index_anggarans_on_tahapan_id  (tahapan_id)
#
# Foreign Keys
#
#  fk_rails_...  (pajak_id => pajaks.id)
#
class Anggaran < ApplicationRecord
  belongs_to :tahapan
  has_many :perhitungans
  # child untuk memanggil id isian bawahnya
  has_many :childs, :class_name => "Anggaran", :foreign_key => "parent_id"
  belongs_to :parent, class_name: "Anggaran", optional: true
  belongs_to :pajak

  scope :tanpa_pajak, -> { where(pajak_id: nil) }
  scope :ujung_anggaran, -> { where(level: 0) }
  scope :pangkal_anggaran, -> { where(level: 5) }

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

  def rekening_level
    if self.level == 4
      rek_level_3 = self.kode_rek[0..-6]
      rek_level_2 = self.kode_rek[0..-9]
      rek_level_1 = self.kode_rek[0..-12]
      rek_level_0 = self.kode_rek[0..-15]
      return { "level_3" => rek_level_3, "level_2" => rek_level_2, "level_1" => rek_level_1, "level_0" => rek_level_0 }
    end
  end
end
