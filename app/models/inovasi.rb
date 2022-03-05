# == Schema Information
#
# Table name: inovasis
#
#  id         :bigint           not null, primary key
#  manfaat    :string
#  usulan     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Inovasi < ApplicationRecord
  validates :usulan, presence: true, length: { minimum: 5 }
end
