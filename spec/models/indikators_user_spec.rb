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
require 'rails_helper'

RSpec.describe IndikatorsUser, type: :model do
  it { should belong_to :indikator }
  it { should belong_to :user }

  it 'should show user indikators' do
    indikator = create(:indikator)
    user = create(:eselon_4)
    indikator_user = IndikatorsUser.create(user: user, indikator: indikator)

    expect(user.indikators).to include(indikator)
  end
end
