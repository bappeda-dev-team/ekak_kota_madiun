# == Schema Information
#
# Table name: rekenings
#
#  id             :bigint           not null, primary key
#  jenis_rekening :string
#  kode_rekening  :string
#  set_input      :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "rails_helper"

RSpec.describe Rekening, type: :model do
  def rekening_level_4
    Rekening.create(
      kode_rekening: "5.1.02.02.08.0026",
      jenis_rekening: "Parent Level 4"
    )
  end

  def rekening_level_3
    Rekening.create(
      kode_rekening: "5.1.02.02.08",
      jenis_rekening: "Parent Level 3"
    )
  end

  def rekening_level_2
    Rekening.create(
      kode_rekening: "5.1.02.02",
      jenis_rekening: "Parent Level 2"
    )
  end

  def rekening_level_1
    Rekening.create(
      kode_rekening: "5.1.02",
      jenis_rekening: "Parent Level 1"
    )
  end

  def rekening_level_0
    Rekening.create(
      kode_rekening: "5.1",
      jenis_rekening: "Grand Parent"
    )
  end

  context "Rekening#parent" do
    it "can determine level 4 parent" do
      rek_parent = rekening_level_3
      rek_sekarang = rekening_level_4
      parent = rek_sekarang.parent
      expect(parent).to eq(rek_parent)
    end
    it "can determine level 3 parent" do
      rek_parent = rekening_level_2
      rek_sekarang = rekening_level_3
      parent = rek_sekarang.parent
      expect(parent).to eq(rek_parent)
    end
    it "can determine level 2 parent" do
      rek_parent = rekening_level_1
      rek_sekarang = rekening_level_2
      parent = rek_sekarang.parent
      expect(parent).to eq(rek_parent)
    end

    it "can determine level 1 parent" do
      rek_parent = rekening_level_0
      rek_sekarang = rekening_level_1
      parent = rek_sekarang.parent
      expect(parent).to eq(rek_parent)
    end
  end

  context "Rekening#grand_parent" do
    it "can determine the grand_parent from any position" do
      rek_grand_parent = rekening_level_0
      rek_sekarang = rekening_level_4
      grand_parent = rek_sekarang.grand_parent
      expect(grand_parent).to eq(rek_grand_parent)
    end
  end

  context "Rekening#level" do
    it "can determine level 4" do
      rekening = rekening_level_4
      level = rekening.level
      expect(level).to eq(4)
    end
    it "can determine any level" do
      expect(rekening_level_2.level).to eq(2)
      expect(rekening_level_1.level).to eq(1)
      expect(rekening_level_3.level).to eq(3)
      expect(rekening_level_0.level).to eq(0)
    end
  end
end
