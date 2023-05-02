# == Schema Information
#
# Table name: strategi_kota
#
#  id                    :bigint           not null, primary key
#  keterangan            :string
#  strategi              :string
#  tahun                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  isu_strategis_kota_id :string
#  sasaran_kota_id       :string
#
require 'rails_helper'

RSpec.describe StrategiKotum, type: :model do
  context 'sasaran kota one on one strategi kota' do
    it 'strategi kota knew sasaran kota' do
      tujuan_kota = FactoryBot.create(:tujuan_kota)
      isu_strategis_kota = FactoryBot.create(:isu_strategis_kotum)
      sasaran_kota = FactoryBot.create(:sasaran_kotum, id_tujuan: tujuan_kota.kode_tujuan, kode_sasaran: 'kode_abc')
      strategi_kota = FactoryBot.create(:strategi_kotum, sasaran_kota_id: 'kode_abc', isu_strategis_kota_id: isu_strategis_kota.id)
      expect(strategi_kota.sasaran_kotum.sasaran).to eq(sasaran_kota.sasaran)
    end
  end
end
