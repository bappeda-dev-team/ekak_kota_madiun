# == Schema Information
#
# Table name: lembagas
#
#  id           :bigint           not null, primary key
#  nama_lembaga :string
#  tahun        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Lembaga, type: :model do
  context 'validation' do
    it { should validate_presence_of(:nama_lembaga) }
  end
  context 'associaton' do
    it { should have_many(:opds) }
  end
end
