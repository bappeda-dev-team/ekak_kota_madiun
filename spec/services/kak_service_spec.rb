require 'rails_helper'

RSpec.describe KakService, type: :model do
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
end
