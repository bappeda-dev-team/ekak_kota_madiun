# == Schema Information
#
# Table name: strategis
#
#  id                    :bigint           not null, primary key
#  linked_with           :bigint
#  metadata              :jsonb
#  nip_asn               :string
#  nip_asn_sebelumnya    :string
#  role                  :string
#  strategi              :string
#  strategi_cascade_link :bigint
#  tahun                 :string
#  type                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  opd_id                :string
#  pohon_id              :bigint
#  sasaran_id            :string
#  strategi_ref_id       :string
#  tujuan_id             :bigint
#
# Indexes
#
#  index_strategis_on_pohon_id  (pohon_id)
#
require 'rails_helper'

RSpec.describe Strategi, type: :model do
  it 'should create new pohon if not exists' do
    strategi = create(:strategi,
                      type: '',
                      strategi: 'contoh a',
                      opd_id: '136',
                      tahun: '2025',
                      role: 'eselon_3')
    expect { strategi.create_new_pohon(role: 'tactical_pohon_kota') }.to change { Pohon.count }.from(0).to(1)
    expect(strategi.pohon).not_to be_nil
    expect(strategi.pohon.role).to eq 'tactical_pohon_kota'
  end
  it 'should return if pohon exists' do
    strategi = create(:strategi,
                      type: '',
                      strategi: 'contoh a',
                      opd_id: '136',
                      tahun: '2025',
                      role: 'eselon_3')
    pohon = create(:pohon,
                   pohonable_id: strategi.id,
                   pohonable_type: 'Strategi',
                   opd_id: '136',
                   tahun: '2025',
                   role: 'tactical_pohon_kota')
    # expect { strategi.create_new_pohon }.not_to change { Pohon.count }.from(0).to(1)
    expect(strategi.pohon).not_to be_nil
    expect(strategi.create_new_pohon).to be_nil
  end
end
