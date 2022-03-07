# == Schema Information
#
# Table name: pokpirs
#
#  id         :bigint           not null, primary key
#  alamat     :string
#  usulan     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Pokpir < ApplicationRecord
  validates :usulan, presence: true

  belongs_to :sasaran, optional: true
end
