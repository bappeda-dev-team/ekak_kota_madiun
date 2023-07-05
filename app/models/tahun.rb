# == Schema Information
#
# Table name: tahuns
#
#  id         :bigint           not null, primary key
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  periode_id :bigint
#
class Tahun < ApplicationRecord
  belongs_to :periode

  validates :tahun, presence: true, inclusion: { in: (2019..2055).map(&:to_s) }
  validates_uniqueness_of :tahun

  def to_s
    tahun
  end
end
