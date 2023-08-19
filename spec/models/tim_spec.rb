# == Schema Information
#
# Table name: tims
#
#  id          :bigint           not null, primary key
#  jabatan     :string
#  jenis       :string
#  keterangan  :string
#  nama_tim    :string
#  nip         :string
#  tahun       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  opd_id      :bigint
#  team_ref_id :bigint
#
# Indexes
#
#  index_tims_on_opd_id  (opd_id)
#
require 'rails_helper'

RSpec.describe Tim, type: :model do
  it { should validate_presence_of(:tahun) }

  describe "Tim Kota" do
    subject(:tim_kota) { create(:tim, nama_tim: 'Tim Contoh', jenis: 'Kota', tahun: '2023') }

    it "can create tim kota, tim without opd " do
      expect(tim_kota).to be_tim_kota
    end

    it 'includes tim with jenis Kota' do
      expect(Tim.tim_kota).to include(tim_kota)
    end

    it 'exclude tim without jenis Kota' do
      tim = create(:tim, nama_tim: 'Tim Contoh', jenis: 'SubTeam', tahun: '2023')
      expect(Tim.tim_kota).not_to include(tim)
    end
  end
end
