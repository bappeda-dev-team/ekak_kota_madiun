# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  atasan                 :string
#  atasan_nama            :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  eselon                 :string
#  id_bidang              :bigint
#  jabatan                :string
#  kode_opd               :string
#  nama                   :string
#  nama_bidang            :string
#  nama_pangkat           :string
#  nik                    :string
#  nip_sebelum            :string
#  pangkat                :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  type                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  lembaga_id             :integer          default(1)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_nik                   (nik) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe Kepala, type: :model do
  let(:asn_kepala) { create(:kepala, nama: 'Test Atasan', nik: '123456_789', type: 'Kepala') }
  let(:asn_bawahan) { create(:user, email: 'test_bawahan_123@email.com', atasan: '123456_789') }

  context 'User with type Kepala' do
    it 'should be Atasan Class' do
      atasan = asn_kepala
      expect(atasan.type).to eq('Kepala')
      expect(atasan).to be_a(Kepala)
    end
  end

  context 'Atasan can see the bawahan' do
    it 'should know who the bawahans is' do
      bawahans = asn_kepala.kabids
      expect(bawahans).to include(asn_bawahan)
    end
  end

  it { should have_many(:kabids) }
end
