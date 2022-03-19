# == Schema Information
#
# Table name: aksis
#
#  id         :bigint           not null, primary key
#  bulan      :integer
#  realisasi  :integer
#  target     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tahapan_id :bigint
#
# Indexes
#
#  index_aksis_on_tahapan_id  (tahapan_id)
#
require 'rails_helper'

RSpec.describe Aksi, type: :model do
  context 'validations' do
    it { should validate_presence_of(:target) }
    it { should validate_numericality_of(:target) }
  end
end
