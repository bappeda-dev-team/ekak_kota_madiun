# == Schema Information
#
# Table name: kelompok_anggarans
#
#  id            :bigint           not null, primary key
#  kelompok      :string
#  kode_kelompok :string
#  tahun         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe KelompokAnggaran, type: :model do
  describe 'validations' do
    it 'tidak valid tanpa kelompok' do
      ka = KelompokAnggaran.create(tahun: 2022)
      expect(ka).to be_invalid
    end

    it 'tidak valid tanpa tahun' do
      kp = KelompokAnggaran.create(kelompok: 'Perubahan')
      expect(kp).to be_invalid
    end

    it 'valid dengan kelompok Awal dan Perubahan' do
      ka = KelompokAnggaran.create(kelompok: 'Awal', tahun: 2022, kode_kelompok: '_awal')
      kp = KelompokAnggaran.create(kelompok: 'Perubahan', tahun: 2022, kode_kelompok: '_perubahan')
      expect(ka).to be_valid
      expect(kp).to be_valid
    end

    it 'tidak valid dengan tahun selain angka' do
      ka = KelompokAnggaran.create(kelompok: 'Awal', tahun: 'zzz', kode_kelompok: '_awal')
      expect(ka).to be_invalid
    end

    it 'tidak valid dengan duplikat tahun dan kode yang sama' do
      KelompokAnggaran.create(kelompok: 'Awal', tahun: 2022, kode_kelompok: '_awal')
      ka2 = KelompokAnggaran.create(kelompok: 'Awal', tahun: 2022, kode_kelompok: '_awal')
      expect(ka2).to be_invalid
    end
  end

  describe 'pembuat kode' do
    it 'membuat kode kelompok dengan pola _awal' do
      ka = KelompokAnggaran.create(kelompok: 'Awal', tahun: 2022)
      expect(ka.kode_kelompok).to eq('_2022_awal')
    end

    it 'membuat kode kelompok dengan pola _perubahan' do
      ka = KelompokAnggaran.create(kelompok: 'Perubahan', tahun: 2022)
      expect(ka.kode_kelompok).to eq('_2022_perubahan')
    end

    context 'lewat validasi' do
      it 'tidak valid jika bukan Awal atau Perubahan' do
        ka2 = KelompokAnggaran.create(kelompok: 'Sendiri', tahun: 2022, kode_kelompok: '_perubahan')
        expect(ka2).to be_invalid
      end
    end
  end

  describe 'pembuat kode untuk kloning sasaran' do
    it 'membuat kode kelompok dengan pola _tahun_kelompok' do
      ka = KelompokAnggaran.create(kelompok: 'Perubahan', tahun: 2022)
      expect(ka.kode_kelompok).to eq('_2022_perubahan')
    end
  end
end
