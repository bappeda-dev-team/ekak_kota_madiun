# == Schema Information
#
# Table name: pks
#
#  id                :bigint           not null, primary key
#  sasaran           :string
#  indikator_kinerja :string
#  target            :string
#  satuan            :string
#  user_id           :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Pk < ApplicationRecord
  belongs_to :user
  has_one :kak
end
