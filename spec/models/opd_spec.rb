# == Schema Information
#
# Table name: opds
#
#  id            :bigint           not null, primary key
#  id_opd_skp    :integer
#  kode_opd      :string
#  kode_unik_opd :string
#  nama_opd      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  lembaga_id    :integer
#
# Indexes
#
#  index_opds_on_kode_opd  (kode_opd) UNIQUE
#
require 'rails_helper'

RSpec.describe Opd, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nama_opd)  }
    it { should validate_presence_of(:kode_opd)  }
  end
end
