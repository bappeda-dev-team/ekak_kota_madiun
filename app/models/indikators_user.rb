# == Schema Information
#
# Table name: indikators_users
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  indikator_id :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_indikators_users_on_indikator_id  (indikator_id)
#  index_indikators_users_on_user_id       (user_id)
#
class IndikatorsUser < ApplicationRecord
  belongs_to :indikator
  belongs_to :user
end
