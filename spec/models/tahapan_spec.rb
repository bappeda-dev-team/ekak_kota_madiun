# == Schema Information
#
# Table name: tahapans
#
#  id               :bigint           not null, primary key
#  bulan            :string
#  id_rencana       :string
#  id_rencana_aksi  :string
#  jumlah_realisasi :integer
#  jumlah_target    :integer
#  keterangan       :string
#  progress         :integer
#  realisasi        :integer
#  tahapan_kerja    :string
#  target           :integer
#  waktu            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  sasaran_id       :bigint
#
# Indexes
#
#  index_tahapans_on_id_rencana_aksi  (id_rencana_aksi) UNIQUE
#  index_tahapans_on_sasaran_id       (sasaran_id)
#
require 'rails_helper'

RSpec.describe Tahapan, type: :model do
  context 'validation' do
    it { should validate_presence_of(:tahapan_kerja) }
  end

  context 'association' do
    it { should belong_to(:sasaran).optional }
    it { should have_many(:aksis) }
    it { should have_many(:anggarans) }
  end
end
