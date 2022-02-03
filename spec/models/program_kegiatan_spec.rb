# == Schema Information
#
# Table name: program_kegiatans
#
#  id                :bigint           not null, primary key
#  nama_program      :string
#  nama_kegiatan     :string
#  nama_subkegiatan  :string
#  indikator_kinerja :string
#  target            :string
#  satuan            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  opd_id            :integer
#
require 'rails_helper'

RSpec.describe ProgramKegiatan, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nama_program)  }
    it { should validate_presence_of(:indikator_kinerja)  }
    it { should validate_presence_of(:target)  }
    it { should validate_presence_of(:satuan)  }
  end
  
end
