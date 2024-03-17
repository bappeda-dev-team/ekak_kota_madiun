# == Schema Information
#
# Table name: permasalahans
#
#  id                :bigint           not null, primary key
#  jenis             :text
#  penyebab_external :string
#  penyebab_internal :string
#  permasalahan      :text
#  tahun             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  sasaran_id        :bigint
#  usulan_id         :bigint
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#
require 'rails_helper'

RSpec.describe Permasalahan, type: :model do
  context 'validation' do
    it { should belong_to(:sasaran).optional(true) }
  end
end
