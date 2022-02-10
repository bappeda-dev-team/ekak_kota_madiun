# == Schema Information
#
# Table name: dasar_hukums
#
#  id         :bigint           not null, primary key
#  judul      :string
#  peraturan  :text
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class DasarHukum < ApplicationRecord
  validates :peraturan, presence: true
  validates :judul, presence: true
  validates :tahun, numericality: { only_integer: true }, length: { is: 4 }
end
