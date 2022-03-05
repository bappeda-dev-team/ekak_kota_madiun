# == Schema Information
#
# Table name: inovasis
#
#  id         :bigint           not null, primary key
#  manfaat    :string
#  usulan     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Inovasi, type: :model do
  context 'validations' do
    it { should validate_presence_of(:usulan)  }
  end
end
