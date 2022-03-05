# == Schema Information
#
# Table name: mandatoris
#
#  id                :bigint           not null, primary key
#  peraturan_terkait :string
#  usulan            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'rails_helper'

RSpec.describe Mandatori, type: :model do
  context 'validation' do
    it { should validate_presence_of(:usulan) }
    it { should validate_presence_of(:peraturan_terkait) }
  end
end
