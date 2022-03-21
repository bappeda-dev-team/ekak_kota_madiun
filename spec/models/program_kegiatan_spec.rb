# == Schema Information
#
# Table name: program_kegiatans
#
#  id                        :bigint           not null, primary key
#  indikator_kinerja         :string
#  indikator_program         :string
#  indikator_subkegiatan     :string
#  kode_opd                  :string
#  nama_kegiatan             :string
#  nama_program              :string
#  nama_subkegiatan          :string
#  satuan                    :string
#  satuan_target_program     :string
#  satuan_target_subkegiatan :string
#  target                    :string
#  target_program            :string
#  target_subkegiatan        :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  subkegiatan_tematik_id    :bigint
#
# Indexes
#
#  index_program_kegiatans_on_subkegiatan_tematik_id  (subkegiatan_tematik_id)
#
# Foreign Keys
#
#  fk_rails_...  (kode_opd => opds.kode_opd)
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
