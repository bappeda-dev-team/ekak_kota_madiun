# == Schema Information
#
# Table name: perhitungans
#
#  id          :bigint           not null, primary key
#  deskripsi   :string
#  harga       :integer
#  satuan      :string
#  spesifikasi :text
#  total       :integer
#  volume      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  anggaran_id :bigint
#
# Indexes
#
#  index_perhitungans_on_anggaran_id  (anggaran_id)
#
require 'rails_helper'

RSpec.describe Perhitungan, type: :model do
  context 'validation' do
    it { should validate_presence_of(:deskripsi) }
    it { should validate_presence_of(:satuan) }
    it { should validate_presence_of(:harga) }
    it { should validate_numericality_of(:harga) }
  end

  context 'association' do
    it { should belong_to(:anggaran) }
    it { should have_many(:koefisiens) }
    it { should accept_nested_attributes_for(:koefisiens) }
  end
end
