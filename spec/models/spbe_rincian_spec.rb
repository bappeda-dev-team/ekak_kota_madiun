# == Schema Information
#
# Table name: spbe_rincians
#
#  id                     :bigint           not null, primary key
#  aspek_spbe             :string
#  detail_kebutuhan       :string
#  detail_sasaran_kinerja :string
#  domain_spbe            :string
#  id_rencana             :string
#  internal_external      :string
#  kebutuhan_spbe         :string
#  keterangan             :string
#  kode_opd               :string
#  kode_program           :string
#  subdomain_spbe         :string
#  tahun_akhir            :string
#  tahun_awal             :string
#  tahun_pelaksanaan      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  spbe_id                :bigint
#  strategi_ref_id        :string
#
require 'rails_helper'

RSpec.describe SpbeRincian, type: :model do
  it { should validate_presence_of :domain_spbe }
  it { should validate_presence_of :aspek_spbe }
  it { should validate_presence_of :subdomain_spbe }
  it { should validate_presence_of :kebutuhan_spbe }
  it { should validate_presence_of :detail_kebutuhan }
  it { should belong_to :spbe }
  it { should belong_to(:sasaran).optional }
  it { should have_one :opd }

  it 'should show empty sasaran as Belum diisi' do
    spbe_rincian = FactoryBot.create :spbe_rincian
    expect(spbe_rincian.sasaran_kinerja).to eq('Belum diisi')
  end
end
