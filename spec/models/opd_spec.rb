require 'rails_helper'

RSpec.describe Opd, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nama_opd)  }
    it { should validate_presence_of(:kode_opd)  }
  end
end
