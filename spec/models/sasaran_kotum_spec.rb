# == Schema Information
#
# Table name: sasaran_kota
#
#  id           :bigint           not null, primary key
#  id_misi      :string
#  id_sasaran   :string
#  id_tujuan    :string
#  kode_sasaran :string
#  misi         :string
#  sasaran      :string
#  tahun_akhir  :string
#  tahun_awal   :string
#  tujuan       :string
#  visi         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tematik_id   :bigint
#
# Indexes
#
#  index_sasaran_kota_on_id_sasaran  (id_sasaran) UNIQUE
#  index_sasaran_kota_on_tematik_id  (tematik_id)
#
require 'rails_helper'

RSpec.describe SasaranKotum, type: :model do
  context 'validation' do
    it { should have_one(:strategi_kotum) }
  end

  context 'sasaran kota one on one strategi kota' do
    it 'sasaran kota knew strategi kota' do
      tematik = FactoryBot.create(:tematik)
      tujuan_kota = FactoryBot.create(:tujuan_kota)
      isu_strategis_kota = FactoryBot.create(:isu_strategis_kotum)
      sasaran_kota = FactoryBot.create(:sasaran_kotum, id_tujuan: tujuan_kota.kode_tujuan, kode_sasaran: 'kode_abc', tematik: tematik)
      strategi_kota = FactoryBot.create(:strategi_kotum, sasaran_kota_id: 'kode_abc', isu_strategis_kota_id: isu_strategis_kota.id)
      expect(sasaran_kota.strategi_kotum.strategi).to eq(strategi_kota.strategi)
    end
  end
end
