# == Schema Information
#
# Table name: jabatans
#
#  id            :bigint           not null, primary key
#  id_jabatan    :bigint
#  index         :string
#  kelas_jabatan :string
#  kode_opd      :string
#  nama_jabatan  :string
#  nilai_jabatan :integer
#  tahun         :string
#  tipe          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe Jabatan, type: :model do
  it { should have_many(:kepegawaians) }

  let(:opd) { create(:opd) }
  let(:jabatan) { create(:jabatan, kode_opd: opd.kode_unik_opd) }

  describe '#jumlah_status_kepegawaian' do
    it 'key valued status kepegawaian and jumlah' do
      Kepegawaian.create(opd: opd, jabatan: jabatan,
                         tahun: '2025',
                         status_kepegawaian: 'PNS',
                         jumlah: 2)
      expect(jabatan.jumlah_status_kepegawaian).to eq({ 'PNS' => 2 })
      expect(jabatan.jumlah_status_kepegawaian['PNS']).to eq 2
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

      expect(jabatan.pendidikan_pegawai).to eq({
                                                 'SD/SMP' => false,
                                                 'SMA' => true,
                                                 'D1/D3' => false,
                                                 'D4/S1' => true,
                                                 'S2/S3' => false
                                               })
      expect(jabatan.pendidikan_pegawai).to include({
                                                      'SD/SMP' => false,
                                                      'SMA' => true,
                                                      'D1/D3' => false,
                                                      'D4/S1' => true,
                                                      'S2/S3' => false
                                                    })
    end
  end
end
