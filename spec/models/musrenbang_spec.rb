# == Schema Information
#
# Table name: musrenbangs
#
#  id         :bigint           not null, primary key
#  tahun      :string
#  usulan     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Musrenbang, type: :model do
  context "Harus punya usulan" do
    it "invalid without usulan" do
      mus = FactoryBot.build(:musrenbang, usulan: nil)
      expect(mus).to_not be_valid
      expect(mus.errors[:usulan]).to include("can't be blank")
    end
  end

  context "harus punya tahun pada usulannya" do
    it "invalid saat tidak ada tahun" do
      mus = FactoryBot.build(:musrenbang, tahun: nil)
      expect(mus).to_not be_valid
      expect(mus.errors[:tahun]).to include("can't be blank")
    end
  end

  context "bisa menyimpan musrenbang" do
    it "valid saat semua terisi" do
      mus = FactoryBot.build(:musrenbang)
      expect(mus).to be_valid
    end
  end

  context "reserved logic" do
    pending "logic masa depan"
  end
end
