# == Schema Information
#
# Table name: pendidikan_terakhirs
#
#  id             :bigint           not null, primary key
#  keterangan     :string
#  pendidikan     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  kepegawaian_id :bigint           not null
#
# Indexes
#
#  index_pendidikan_terakhirs_on_kepegawaian_id  (kepegawaian_id)
#
# Foreign Keys
#
#  fk_rails_...  (kepegawaian_id => kepegawaians.id)
#
require 'rails_helper'

RSpec.describe PendidikanTerakhir, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
