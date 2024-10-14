# == Schema Information
#
# Table name: spbes
#
#  id                  :bigint           not null, primary key
#  jenis_pelayanan     :string
#  kode_opd            :string
#  kode_program        :string
#  nama_aplikasi       :string
#  output_aplikasi     :string
#  output_cetak        :string
#  output_data         :string
#  output_informasi    :string
#  pemilik_aplikasi    :string
#  terintegrasi_dengan :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#  strategi_id         :bigint
#  strategi_ref_id     :string
#
require 'rails_helper'

RSpec.describe Spbe, type: :model do
  it { should validate_presence_of :strategi_ref_id }
  it { should validate_presence_of :nama_aplikasi }
  it { should validate_presence_of :program_kegiatan_id }
  it { should belong_to :program_kegiatan }
  it { should have_one :opd }
  it { should have_one :sasaran }
  it { should have_many :spbe_rincians }

  it 'should display nama_program' do
    spbe = FactoryBot.create :spbe
    expect(spbe.nama_program).to eq('Test program')
  end

  it 'should display sasaran tactical' do
    spbe = FactoryBot.create :spbe
    expect(spbe.sasaran.sasaran_kinerja).to eq('Test sasaran')
  end
end
