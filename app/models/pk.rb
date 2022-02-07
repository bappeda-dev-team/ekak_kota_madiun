# == Schema Information
#
# Table name: pks
#
#  id                :bigint           not null, primary key
#  indikator_kinerja :string
#  sasaran           :string
#  satuan            :string
#  target            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_pks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Pk < ApplicationRecord
  belongs_to :user
  has_one :kak
end
