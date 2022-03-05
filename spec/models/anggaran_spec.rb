# frozen_string_literal: true

# == Schema Information
#
# Table name: anggarans
#
#  id         :bigint           not null, primary key
#  jumlah     :integer
#  kode_rek   :string
#  level      :integer          default(0)
#  set_input  :string           default("0")
#  tahun      :integer
#  uraian     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pajak_id   :bigint
#  parent_id  :bigint
#  tahapan_id :bigint
#
# Indexes
#
#  index_anggarans_on_pajak_id    (pajak_id)
#  index_anggarans_on_parent_id   (parent_id)
#  index_anggarans_on_tahapan_id  (tahapan_id)
#
# Foreign Keys
#
#  fk_rails_...  (pajak_id => pajaks.id)
#
require 'rails_helper'

RSpec.describe Anggaran, type: :model do
  context 'validation' do
    it { should validate_presence_of(:uraian) }
  end

  context 'association' do
    it { should belong_to(:tahapan) }
    it { should belong_to(:pajak) }
    it { should have_many(:perhitungans) }
  end

  context 'parent-child' do
    it { should belong_to(:parent).class_name('Anggaran').optional }
    it { should have_many(:childs).class_name('Anggaran') }
  end
end
