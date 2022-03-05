# == Schema Information
#
# Table name: pajaks
#
#  id         :bigint           not null, primary key
#  tahun      :string
#  tipe       :string
#  potongan   :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Pajak, type: :model do
  context 'validation' do
    it { should validate_presence_of(:potongan) }
    it { should validate_numericality_of(:potongan) }
    it { should validate_presence_of(:tipe) }
  end
  context '#simple_pajak' do
    subject { build(:pajak) }
    it { expect(subject.simple_pajak).to eq('10%') }
  end
end
