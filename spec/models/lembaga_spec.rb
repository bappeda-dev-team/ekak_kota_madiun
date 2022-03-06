require 'rails_helper'

RSpec.describe Lembaga, type: :model do
  context 'validation' do
    it {should validate_presence_of(:nama_lembaga)}
  end
  context 'associaton' do
    it {should have_many(:opds)}
  end
end
