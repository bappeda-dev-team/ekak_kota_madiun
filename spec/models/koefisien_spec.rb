# == Schema Information
#
# Table name: koefisiens
#
#  id             :bigint           not null, primary key
#  satuan_volume  :string
#  volume         :decimal(, )
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
  context 'validation' do
    it { should validate_presence_of(:volume) }
  end
  context 'association' do
    it { should belong_to(:perhitungan) }
  end
end
