# == Schema Information
#
# Table name: kesenjangans
#
#  id          :bigint           not null, primary key
#  akses       :string
#  kontrol     :string
#  manfaat     :string
#  partisipasi :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  rincian_id  :bigint           not null
#
# Indexes
#
#  index_kesenjangans_on_rincian_id  (rincian_id)
#
# Foreign Keys
#
#  fk_rails_...  (rincian_id => rincians.id)
#
class Kesenjangan < ApplicationRecord
end
