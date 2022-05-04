# == Schema Information
#
# Table name: subkegiatan_tematiks
#
#  id           :bigint           not null, primary key
#  kode_tematik :string
#  nama_tematik :string
#  tahun        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe SubkegiatanTematik, type: :model do
  context 'validation' do
    it { should validate_presence_of(:kode_tematik) }
    it { should validate_presence_of(:nama_tematik) }
  end

  context 'association' do
    it { should have_many(:program_kegiatans) }
    it { should have_many(:sasarans) }
    it { should have_many(:tematik_sasarans) }
  end
end
