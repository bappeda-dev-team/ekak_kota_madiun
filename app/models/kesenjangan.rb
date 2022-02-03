# == Schema Information
#
# Table name: kesenjangans
#
#  id          :bigint           not null, primary key
#  rincian_id  :bigint           not null
#  akses       :string
#  partisipasi :string
#  kontrol     :string
#  manfaat     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Kesenjangan < ApplicationRecord
end
