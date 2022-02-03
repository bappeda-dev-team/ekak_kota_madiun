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
require 'rails_helper'

RSpec.describe Kesenjangan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
