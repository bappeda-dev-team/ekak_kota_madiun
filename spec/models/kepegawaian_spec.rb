# == Schema Information
#
# Table name: kepegawaians
#
#  id                 :bigint           not null, primary key
#  jumlah             :integer
#  status_kepegawaian :string
#  tahun              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  jabatan_id         :bigint           not null
#  opd_id             :bigint
#
# Indexes
#
#  index_kepegawaians_on_jabatan_id  (jabatan_id)
#  index_kepegawaians_on_opd_id      (opd_id)
#
# Foreign Keys
#
#  fk_rails_...  (jabatan_id => jabatans.id)
#
require 'rails_helper'

RSpec.describe Kepegawaian, type: :model do
  it { should belong_to(:jabatan) }
  it { should belong_to(:opd) }
  it { should have_many(:pendidikan_terakhirs) }

  it { should validate_presence_of(:status_kepegawaian) }
  it { should validate_presence_of(:tahun) }

  context 'opd - jabatan kepegawaian - pendidikan' do
    let(:opd) { create(:opd) }
    let(:jabatan) { create(:jabatan, kode_opd: opd.kode_unik_opd) }

    it 'should save with opd and jabatan' do
      kepegawaian = Kepegawaian.create(opd: opd, jabatan: jabatan,
                                       tahun: '2025',
                                       status_kepegawaian: 'PNS',
                                       jumlah: 2)
      jabatan_kepegawaian = opd.jabatans.map { |jb| jb.kepegawaians }.flatten
      expect(jabatan_kepegawaian).to include(kepegawaian)
    end

    it 'pendidikan pegawai list all pendidikan terakhir' do
      kepegawaian = Kepegawaian.create(opd: opd, jabatan: jabatan,
                                       tahun: '2025',
                                       status_kepegawaian: 'PNS',
                                       jumlah: 2)
      d4_s1 = PendidikanTerakhir.create(kepegawaian: kepegawaian,
                                        pendidikan: 'D4/S1',
                                        keterangan: 'contoh')
      s2_s3 = PendidikanTerakhir.create(kepegawaian: kepegawaian,
                                        pendidikan: 'S2/S3',
                                        keterangan: 'contoh')
      expect(kepegawaian.pendidikan_pegawai).to eq({ 'D4/S1' => true,
                                                     'S2/S3' => true,
                                                     'SMP/SMA' => false })
    end

    it 'return false in value if no pendidikan' do
      kepegawaian = Kepegawaian.create(opd: opd, jabatan: jabatan,
                                       tahun: '2025',
                                       status_kepegawaian: 'PNS',
                                       jumlah: 2)
      expect(kepegawaian.pendidikan_pegawai).to eq({ 'D4/S1' => false,
                                                     'S2/S3' => false,
                                                     'SMP/SMA' => false })
    end
  end
end
