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
  it { should allow_value('2023').for(:tahun) }
  it { should_not allow_value('1995').for(:tahun) }

  let(:tim_kota) { create(:tim, nama_tim: 'Tim Contoh', jenis: 'Kota', tahun: '2023') }
  let(:sub_tim) do
    create(:tim, nama_tim: 'Sub Tim Contoh', jenis: 'SubTeam', tahun: '2023',
                 team_ref_id: tim_kota.id)
  end

  describe "Tim Kota" do
    it "can create tim kota, tim without opd " do
      expect(tim_kota).to be_tim_kota
    end

    it 'includes tim with jenis Kota' do
      expect(Tim.tim_kota).to include(tim_kota)
    end

    it 'exclude tim without jenis Kota' do
      expect(Tim.tim_kota).not_to include(sub_tim)
    end
  end

  describe "Sub Tim" do
    it 'show collection of SubTeam' do
      sub_teams = tim_kota.sub_tims
      expect(sub_teams).to include(sub_tim)
    end
    it 'have tim kota as parent tim' do
      expect(sub_tim.parent_tim).to eq(tim_kota)
    end

    it 'nil if no parent' do
      sub_tim = create(:tim, nama_tim: 'Wrong Team', jenis: 'SubTeam', tahun: '2023')
      expect(sub_tim.parent_tim).to be_nil
    end
  end
end
