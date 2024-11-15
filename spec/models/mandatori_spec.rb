# == Schema Information
#
# Table name: mandatoris
#
#  id                :bigint           not null, primary key
#  is_active         :boolean          default(FALSE)
#  nip_asn           :string
#  opd               :string
#  peraturan_terkait :string
#  status            :enum             default("draft")
#  tahun             :string
#  uraian            :string
#  urutan            :integer          default(1), not null
#  usulan            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  sasaran_id        :bigint
#
# Indexes
#
#  index_mandatoris_on_sasaran_id  (sasaran_id)
#  index_mandatoris_on_status      (status)
#
require 'rails_helper'

RSpec.describe Mandatori, type: :model do
  context 'validation' do
    it { should validate_presence_of(:usulan) }
    it { should validate_presence_of(:peraturan_terkait) }
  end

  context 'association' do
    it { should belong_to(:sasaran).optional }
  end
end
