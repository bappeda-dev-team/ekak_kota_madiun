# == Schema Information
#
# Table name: opds
#
#  id         :bigint           not null, primary key
#  nama_opd   :string
#  kode_opd   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lembaga_id :integer
#
require 'rails_helper'

RSpec.describe Opd, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nama_opd)  }
    it { should validate_presence_of(:kode_opd)  }
  end
end
