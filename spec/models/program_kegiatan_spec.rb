# == Schema Information
#
# Table name: program_kegiatans
#
#  id                     :bigint           not null, primary key
#  indikator_kinerja      :string
#  nama_kegiatan          :string
#  nama_program           :string
#  nama_subkegiatan       :string
#  satuan                 :string
#  target                 :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  opd_id                 :integer
#  subkegiatan_tematik_id :bigint
#
# Indexes
#
#  index_program_kegiatans_on_subkegiatan_tematik_id  (subkegiatan_tematik_id)
#
# Foreign Keys
#
#  fk_rails_...  (subkegiatan_tematik_id => subkegiatan_tematiks.id)
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
