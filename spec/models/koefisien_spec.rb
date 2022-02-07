# == Schema Information
#
# Table name: koefisiens
#
#  id             :bigint           not null, primary key
#  satuan_volume  :string
#  volume         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  perhitungan_id :bigint
#
# Indexes
#
#  index_koefisiens_on_perhitungan_id  (perhitungan_id)
#
require 'rails_helper'

RSpec.describe Koefisien, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
