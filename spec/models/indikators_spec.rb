require 'rails_helper'

RSpec.describe Indikator, type: :model do
  it 'should create indikator using hash' do
    indikator_hash = {}
    indikator_hash[:indikator] = 'Indikator test'
    indikator_hash[:jenis] = 'Test'
    indikator_hash[:sub_jenis] = 'Test'
    indikator_hash[:rumus_perhitungan] = 'Rumus Test'
    indikator_hash[:sumber_data] = 'Sumber X'
    indikator_hash[:tahun] = '2025'
    indikator_hash[:kode_opd] = 'test_opd'

    indikator = Indikator.create(indikator_hash)

    expect(indikator).to be_valid
    expect(indikator.rumus_perhitungan).to eq('Rumus Test')
    expect(indikator.sumber_data).to eq('Sumber X')
  end
  it 'should create indikator and target using hash ' do
    indikator_hash = {}
    indikator_hash[:indikator] = 'Indikator test'
    indikator_hash[:jenis] = 'Test'
    indikator_hash[:sub_jenis] = 'Test'
    indikator_hash[:rumus_perhitungan] = 'Rumus Test'
    indikator_hash[:sumber_data] = 'Sumber X'
    indikator_hash[:tahun] = '2025'
    indikator_hash[:kode_opd] = 'test_opd'

    indikator = Indikator.create(indikator_hash)

    target_hash = {}
    target_hash[:target] = '-'
    target_hash[:satuan] = '-'
    target_hash[:tahun] = '2025'

    target = indikator.targets.create(target_hash)

    expect(target).to be_valid
    expect(indikator.targets).to include target
  end

  context '#sum_pagu_renstra' do
    it 'sum total pagu kegiatan from subkegiatan' do
      Indikator.create(jenis: 'Renstra',
                       sub_jenis: 'Subkegiatan',
                       kode_opd: '123',
                       pagu: '200',
                       kode: '123_456_789')
      ind_kegiatan = Indikator.create(jenis: 'Renstra',
                                      sub_jenis: 'Kegiatan',
                                      kode_opd: '123',
                                      kode: '123_456')
      pagu_kegiatan = ind_kegiatan.sum_pagu_renstra(sub_jenis: 'Subkegiatan')
      expect(pagu_kegiatan).to eq(200)
    end
    it 'sum total pagu kegiatan from any subkegiatan' do
      Indikator.create(jenis: 'Renstra',
                       sub_jenis: 'Subkegiatan',
                       kode_opd: '123',
                       pagu: '200',
                       kode: '123_456_789')
      Indikator.create(jenis: 'Renstra',
                       sub_jenis: 'Subkegiatan',
                       kode_opd: '123',
                       pagu: '200',
                       kode: '123_456_888')
      ind_kegiatan = Indikator.create(jenis: 'Renstra',
                                      sub_jenis: 'Kegiatan',
                                      kode_opd: '123',
                                      kode: '123_456')
      pagu_kegiatan = ind_kegiatan.sum_pagu_renstra(sub_jenis: 'Subkegiatan')
      expect(pagu_kegiatan).to eq(400)
    end
  end
end
