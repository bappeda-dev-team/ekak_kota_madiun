# == Schema Information
#
# Table name: jabatans
#
#  id               :bigint           not null, primary key
#  id_jabatan       :bigint
#  index            :string
#  kelas_jabatan    :string
#  kode_opd         :string
#  nama_jabatan     :string
#  nilai_jabatan    :integer
#  tahun            :string
#  tipe             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  jenis_jabatan_id :bigint
#
# Indexes
#
#  index_jabatans_on_jenis_jabatan_id  (jenis_jabatan_id)
#
require 'rails_helper'

RSpec.describe Jabatan, type: :model do
  context 'validation' do
    it { should have_many(:kepegawaians) }
    it { should validate_presence_of(:nama_jabatan) }
    it { should validate_length_of(:nama_jabatan).is_at_least(5) }
  end

  let(:opd) { create(:opd) }
  let(:jenis_jabatan) { create(:jenis_jabatan) }
  let(:jabatan) { create(:jabatan, kode_opd: opd.kode_unik_opd, jenis_jabatan: jenis_jabatan) }

  describe '#jumlah_status_kepegawaian' do
    it 'key valued status kepegawaian and jumlah' do
      Kepegawaian.create(opd: opd, jabatan: jabatan,
                         tahun: '2025',
                         status_kepegawaian: 'PNS',
                         jumlah: 2)
      expect(jabatan.jumlah_status_kepegawaian('2025')).to eq({ 'PNS' => 2 })
      expect(jabatan.jumlah_status_kepegawaian('2025')['PNS']).to eq 2
    end
  end

  describe '#pendidikan_pegawai' do
    it 'show pendidikan terakhir for each jabatan' do
      kepegawaian = Kepegawaian.create(opd: opd, jabatan: jabatan,
                                       tahun: '2025',
                                       status_kepegawaian: 'PNS',
                                       jumlah: 2)
      sarjana = PendidikanTerakhir.create(kepegawaian: kepegawaian,
                                          pendidikan: 'D4/S1')
      sma = PendidikanTerakhir.create(kepegawaian: kepegawaian,
                                      pendidikan: 'SMA')

      expect(jabatan.pendidikan_pegawai('2025')).to eq(['D4/S1', 'SMA'])
    end
  end

  it 'always have uppercased nama jabatan' do
    jabatan_kepala_bappeda = Jabatan.new(nama_jabatan: 'Kepala Bappeda',
                                         nilai_jabatan: 20)
    jabatan_kepala_bappeda.save
    expect(jabatan_kepala_bappeda.nama_jabatan).to eq('KEPALA BAPPEDA')
  end

  context '#nama_jenis_jabatan' do
    it 'show nama_jenis of jabatan' do
      jabatan_pimpinan_tinggi = JenisJabatan.create(nama_jenis: 'Jabatan Pimpinan Tinggi',
                                                    nilai: 1)
      jabatan_kepala_bappeda = Jabatan.create(nama_jabatan: 'Kepala Bappeda',
                                              nilai_jabatan: 20,
                                              jenis_jabatan: jabatan_pimpinan_tinggi)
      expect(jabatan_kepala_bappeda.nama_jenis_jabatan).to eq('Jabatan Pimpinan Tinggi')
    end
  end
end
