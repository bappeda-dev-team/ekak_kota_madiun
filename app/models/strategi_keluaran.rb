# == Schema Information
#
# Table name: strategi_keluarans
#
#  id         :bigint           not null, primary key
#  metode     :text
#  tahapan    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class StrategiKeluaran < ApplicationRecord
  has_rich_text :metode
  has_rich_text :tahapan

  validates :metode, presence: true
end
