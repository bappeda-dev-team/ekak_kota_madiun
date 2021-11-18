require 'rails_helper'

RSpec.describe ProgramKegiatan, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nama_program)  }
    it { should validate_presence_of(:indikator_kinerja)  }
    it { should validate_presence_of(:target)  }
    it { should validate_presence_of(:satuan)  }
  end
  
end
