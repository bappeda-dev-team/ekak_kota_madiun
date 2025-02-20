# == Schema Information
#
# Table name: inovasis
#
#  id           :bigint           not null, primary key
#  is_active    :boolean          default(FALSE)
#  is_from_kota :boolean          default(FALSE)
#  manfaat      :string
#  nip_asn      :string
#  opd          :string
#  status       :enum             default("draft")
#  tahun        :string
#  uraian       :string
#  usulan       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  misi_id      :bigint
#  sasaran_id   :bigint
#
# Indexes
#
#  index_inovasis_on_misi_id     (misi_id)
#  index_inovasis_on_sasaran_id  (sasaran_id)
#  index_inovasis_on_status      (status)
#
# Foreign Keys
#
#  fk_rails_...  (misi_id => misis.id)
#
require 'rails_helper'

RSpec.describe Inovasi, type: :model do
  context 'validations' do
    it { should validate_presence_of(:usulan) }
  end
  context 'relationship' do
    it { should belong_to(:sasaran).optional }
  end
end
