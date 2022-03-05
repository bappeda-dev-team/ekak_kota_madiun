# == Schema Information
#
# Table name: pokpirs
#
#  id         :bigint           not null, primary key
#  alamat     :string
#  usulan     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Pokpir, type: :model do
  context 'validations' do
    it { should validate_presence_of(:usulan)  }
  end
end
