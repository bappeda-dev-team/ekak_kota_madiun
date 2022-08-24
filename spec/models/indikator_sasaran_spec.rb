# == Schema Information
#
# Table name: indikator_sasarans
#
#  id                :bigint           not null, primary key
#  aspek             :string
#  id_indikator      :string
#  indikator_kinerja :string
#  satuan            :string
#  target            :string
#  type              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  sasaran_id        :string
#
# Indexes
#
#  index_indikator_sasarans_on_id_indikator  (id_indikator) UNIQUE
#
require 'rails_helper'

RSpec.describe IndikatorSasaran, type: :model do
  context 'validation' do
    it { should belong_to(:sasaran).optional }
  end
end
