require 'rails_helper'

RSpec.describe KakService, type: :model do
  let(:kode_opd) { '5.01.5.05.0.00.02.0000' }

  def setup_opd_with_programs(*args)
    opd = FactoryBot.create(:opd, kode_unik_opd: kode_opd)
    5.times { FactoryBot.create(:program_kegiatan, opd: opd, isu_strategis: args[0]) }
  end

  describe '#tahun' do
    let(:kode_opd) { '5.01.5.05.0.00.02.0000' }
    context 'when tahun is murni' do
      it 'change to tahun biasa tanpa underscore' do
        tahun = '2023_murni'
        kak = KakService.new(kode_unik_opd: kode_opd, tahun: tahun)
        expect(kak.tahun).to eq('2023')
      end
    end
    context 'when tahun is clone (perubahan)' do
      it 'keep tahun in perubahan' do
        tahun = '2023_perubahan'
        kak = KakService.new(kode_unik_opd: kode_opd, tahun: tahun)
        expect(kak.tahun).to eq('2023_perubahan')
      end
    end
    context 'outside the known scope' do
      it 'not transform tahun if no underscore' do
        tahun = '2023'
        kak = KakService.new(kode_unik_opd: kode_opd, tahun: tahun)
        expect(kak.tahun).to eq('2023')
      end
      it 'transform *_murni to just tahun' do
        tahun = '2023_perubahan_murni'
        kak = KakService.new(kode_unik_opd: kode_opd, tahun: tahun)
        expect(kak.tahun).to eq('2023')
      end
      it 'not transform _ except _murni' do
        tahun = '2023_'
        kak = KakService.new(kode_unik_opd: kode_opd, tahun: tahun)
        expect(kak.tahun).to eq('2023_')
      end
    end
  end

  describe '#isu_strategis' do
    it 'should returning hash' do
      setup_opd_with_programs
      kak_service = KakService.new(kode_unik_opd: kode_opd, tahun: 2022)
      isu_strategis = kak_service.isu_strategis
      expect(isu_strategis).to be_kind_of(Hash)
    end
    context 'group by kode_program' do
      it 'should have kode_program as key' do
        setup_opd_with_programs
        isu_strategis = KakService.new(kode_unik_opd: kode_opd, tahun: 2023).isu_strategis
        expect(isu_strategis).to have_key('5.01.01')
      end
      it 'should have isu_strategis as value' do
        setup_opd_with_programs('contoh isu strategis_1') # we test isu strategis with input of contoh isu strategis_1
        isu_strategis = KakService.new(kode_unik_opd: kode_opd, tahun: 2023).isu_strategis
        test_value = isu_strategis['5.01.01']
        expect(test_value.first).to include(isu_strategis: 'contoh isu strategis_1')
      end
    end
  end
end
