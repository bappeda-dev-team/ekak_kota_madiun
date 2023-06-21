# == Schema Information
#
# Table name: komentars
#
#  id         :bigint           not null, primary key
#  item       :bigint
#  jenis      :string
#  judul      :string
#  kode_opd   :string
#  komentar   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_komentars_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Komentar, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
