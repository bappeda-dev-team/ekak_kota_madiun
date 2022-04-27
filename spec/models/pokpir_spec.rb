# == Schema Information
#
# Table name: pokpirs
#
#  id         :bigint           not null, primary key
#  alamat     :string
#  id_kamus   :bigint
#  id_unik    :bigint
#  is_active  :boolean          default(FALSE)
#  nip_asn    :string
#  opd        :string
#  status     :enum             default("draft")
#  tahun      :string
#  uraian     :string
#  usulan     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sasaran_id :bigint
#
# Indexes
#
#  index_pokpirs_on_sasaran_id  (sasaran_id)
#  index_pokpirs_on_status      (status)
#
require 'rails_helper'

RSpec.describe Pokpir, type: :model do
  context 'validations' do
    it { should validate_presence_of(:usulan) }
  end

  context 'association' do
    it { should belong_to(:sasaran).optional }
  end
end
