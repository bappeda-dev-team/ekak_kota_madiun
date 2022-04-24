# == Schema Information
#
# Table name: comments
#
#  id          :bigint           not null, primary key
#  body        :text             not null
#  head        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  anggaran_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_comments_on_anggaran_id  (anggaran_id)
#  index_comments_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (anggaran_id => anggarans.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'validation' do
    it { should belong_to(:anggaran) }
    it { should belong_to(:user) }
    it { should validate_presence_of(:body) }
  end
end
