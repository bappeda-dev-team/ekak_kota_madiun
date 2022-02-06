require 'rails_helper'

RSpec.describe Musrenbang, type: :model do
  context "Kota Madiun" do

    it "invalid without usulan" do
      mus = FactoryBot.create(:musrenbang)
      expect(mus).to_not be_valid
    end



  end
end
