# == Schema Information
#
# Table name: koefisiens
#
#  id             :bigint           not null, primary key
#  volume         :integer
#  satuan_volume  :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  perhitungan_id :bigint
#
require 'rails_helper'

RSpec.describe Koefisien, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
