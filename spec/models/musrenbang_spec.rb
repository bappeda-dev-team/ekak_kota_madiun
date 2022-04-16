# == Schema Information
#
# Table name: musrenbangs
#
#  id         :bigint           not null, primary key
#  alamat     :text
#  is_active  :boolean          default(FALSE)
#  nip_asn    :string
#  opd        :string
#  status     :enum             default("draft")
#  tahun      :string
#  usulan     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sasaran_id :bigint
#
# Indexes
#
#  index_musrenbangs_on_sasaran_id  (sasaran_id)
#  index_musrenbangs_on_status      (status)
#
require 'rails_helper'

RSpec.describe Musrenbang, type: :model do
  context 'isian usulan' do
    it 'invalid without usulan' do
      mus = FactoryBot.build(:musrenbang, usulan: nil)
      expect(mus).to_not be_valid
      expect(mus.errors[:usulan]).to include("can't be blank")
    end
  end

  context 'isian tahun' do
    it 'invalid saat tidak ada tahun' do
      mus = FactoryBot.build(:musrenbang, tahun: nil)
      expect(mus).to_not be_valid
      expect(mus.errors[:tahun]).to include("can't be blank")
    end

    it 'invalid saat diisi selain tahun' do
      mus = FactoryBot.build(:musrenbang, tahun: 'error_year')
      expect(mus).to_not be_valid
    end

    it 'valid saat diisi tahun dengan integer' do
      mus = FactoryBot.build(:musrenbang, tahun: 2025)
      expect(mus).to be_valid
    end
  end

  context 'bisa menyimpan musrenbang' do
    it 'valid saat semua terisi' do
      mus = FactoryBot.build(:musrenbang)
      expect(mus).to be_valid
    end
  end

  context 'associaton' do
    it { should belong_to(:sasaran).optional }
  end
end
