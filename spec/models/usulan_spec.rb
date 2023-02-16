# == Schema Information
#
# Table name: usulans
#
#  id              :bigint           not null, primary key
#  keterangan      :string
#  usulanable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  opd_id          :bigint
#  sasaran_id      :bigint
#  usulanable_id   :bigint
#
# Indexes
#
#  index_usulans_on_opd_id      (opd_id)
#  index_usulans_on_sasaran_id  (sasaran_id)
#  index_usulans_on_usulanable  (usulanable_type,usulanable_id)
#
require 'rails_helper'

RSpec.describe Usulan, type: :model do
  context 'can store different usulan type' do
    let(:musren) { build :musrenbang }
    let(:pokokpir) { build :pokpir }
    let(:mandator) { build :mandatori }
    it 'can store musrenbang' do
      usulan = Usulan.create(keterangan: "Musrenbang test", usulanable: musren)
      expect(usulan).to be_valid
    end
    it 'can store pokok pikiran' do
      usulan = Usulan.create(keterangan: "Pokok Pikiran test", usulanable: pokokpir)
      expect(usulan).to be_valid
    end
    it 'can store mandatori' do
      usulan = Usulan.create(keterangan: "Mandatori test", usulanable: mandator)
      expect(usulan).to be_valid
    end
  end

  it { should belong_to(:sasaran).optional }
end
