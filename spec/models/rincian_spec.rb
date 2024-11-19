# == Schema Information
#
# Table name: rincians
#
#  id                  :bigint           not null, primary key
#  dampak              :string
#  data_terpilah       :string
#  lokasi_pelaksanaan  :string
#  model_layanan       :string
#  penyebab_external   :string
#  penyebab_internal   :string
#  permasalahan_gender :string
#  permasalahan_umum   :string
#  resiko              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  kemungkinan_id      :integer
#  sasaran_id          :bigint           not null
#  skala_id            :bigint
#
# Indexes
#
#  index_rincians_on_sasaran_id  (sasaran_id)
#  index_rincians_on_skala_id    (skala_id)
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#
require 'rails_helper'

RSpec.describe Rincian, type: :model do
  let(:sasaran) { FactoryBot.create :sasaran }

  context 'validates relation and property' do
    it { should have_many(:kesenjangans) }

    it { should belong_to(:sasaran).optional }
  end

  context 'rincian created' do
    it 'create and attach to sasaran' do
      rincian = FactoryBot.create :rincian, sasaran: sasaran
      expect(rincian).to be_valid
      expect(sasaran.rincian).to eq rincian
    end

    it 'manually create rincian, then attach to sasarn' do
      rincian_custom = Rincian.create(data_terpilah: 'contoh data terpilah',
                                      lokasi_pelaksanaan: 'contoh lokasi pelaksanaan', sasaran: sasaran)
      expect(rincian_custom).to be_valid
    end
  end
end
