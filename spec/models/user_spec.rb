require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nama)  }
    it { should validate_presence_of(:nik)  }
    it { should validate_presence_of(:password)  }
  end
end
