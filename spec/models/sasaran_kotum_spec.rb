require 'rails_helper'

RSpec.describe SasaranKotum, type: :model do
  context 'validation' do
    it { should have_one(:strategi_kotum) }
  end

  context 'sasaran kota one on one strategi kota' do
    it 'sasaran kota knew strategi kota' do
      tujuan_kota = FactoryBot.create(:tujuan_kota)
      isu_strategis_kota = FactoryBot.create(:isu_strategis_kotum)
      sasaran_kota = FactoryBot.create(:sasaran_kotum, id_tujuan: tujuan_kota.kode_tujuan, kode_sasaran: 'kode_abc')
      strategi_kota = FactoryBot.create(:strategi_kotum, sasaran_kota_id: 'kode_abc', isu_strategis_kota_id: isu_strategis_kota.id)
      expect(sasaran_kota.strategi_kotum.strategi).to eq(strategi_kota.strategi)
    end
  end
end
