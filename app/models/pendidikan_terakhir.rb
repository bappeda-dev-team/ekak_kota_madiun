# == Schema Information
#
# Table name: pendidikan_terakhirs
#
#  id             :bigint           not null, primary key
#  jumlah         :integer
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
class PendidikanTerakhir < ApplicationRecord
  belongs_to :kepegawaian
end
