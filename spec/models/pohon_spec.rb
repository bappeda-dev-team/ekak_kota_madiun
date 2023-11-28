# == Schema Information
#
# Table name: pohons
#
#  id             :bigint           not null, primary key
#  keterangan     :string
#  metadata       :jsonb
#  pohonable_type :string
#  role           :string
#  status         :string
#  tahun          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  opd_id         :bigint
#  pohon_ref_id   :bigint
#  pohonable_id   :bigint
#  strategi_id    :bigint
#  user_id        :bigint
#
# Indexes
#
#  index_pohons_on_opd_id       (opd_id)
#  index_pohons_on_pohonable    (pohonable_type,pohonable_id)
#  index_pohons_on_strategi_id  (strategi_id)
#  index_pohons_on_user_id      (user_id)
#
require 'rails_helper'

RSpec.describe Pohon, type: :model do
  it 'should create StrategiPohon' do
    strategi = create(:strategi, strategi: 'test', role: 'eselon_2', type: '')
    pohon = create(:pohon, pohonable_type: 'Strategi', pohonable_id: strategi.id,
                           keterangan: 'test', tahun: '2025')
    strategi_pohon = pohon.add_strategi_pohon

    expect(strategi_pohon.type).to eq('StrategiPohon')
    expect(strategi_pohon.keterangan).to eq('--dari kota--')
    # expect { strategi_pohon }.to change { StrategiPohon.count }.from(1).to(2)
  end
end
