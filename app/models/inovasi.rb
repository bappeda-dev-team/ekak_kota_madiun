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
end
