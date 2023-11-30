# == Schema Information
#
# Table name: tematiks
#
#  id             :bigint           not null, primary key
#  keterangan     :string
#  level          :integer          default(1)
#  tahun          :string
#  tema           :string
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tematik_ref_id :bigint
#
require 'rails_helper'

RSpec.describe Tematik, type: :model do
  it { should have_many(:indikators) }

  context "save indikator" do
    it "should save indikaor with jenis Tematik and sub_jenis Tematik" do
      tematik = Tematik.create(tema: 'Contoh', keterangan: 'Contoh Keterangan')
      indikator = Indikator.create(indikator: 'Indikator Contoh',
                                   jenis: 'Tematik',
                                   sub_jenis: 'Tematik',
                                   target: '100',
                                   satuan: '%',
                                   tahun: '2023',
                                   kode: tematik.id)
      expect(tematik.indikators).to include(indikator)
    end
  end

  context 'pohon_list' do
    it 'should show pohon tematik and the year' do
      tematik = create(:tematik, tema: 'contoh 1', keterangan: 'keterangan')
      create(:indikator, indikator: 'Indikator Contoh',
                         jenis: 'Tematik',
                         sub_jenis: 'Tematik',
                         target: '100',
                         satuan: '%',
                         tahun: '2023',
                         kode: tematik.id)
      pohon = create(:pohon,
                     pohonable_type: 'Tematik',
                     pohonable_id: tematik.id,
                     keterangan: 'contoh tematik',
                     tahun: '2023',
                     role: 'pohon_kota')
      expect(tematik.pohon_list).to eq([[pohon.id, pohon.tahun]])
    end
  end
end
