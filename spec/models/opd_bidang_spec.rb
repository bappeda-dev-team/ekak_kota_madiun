# == Schema Information
#
# Table name: opd_bidangs
#
#  id               :bigint           not null, primary key
#  id_daerah        :string
#  kode_unik_bidang :string
#  kode_unik_opd    :string
#  nama_bidang      :string
#  nip_kepala       :string
#  pangkat_kepala   :string
#  tahun            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  lembaga_id       :bigint
#  opd_id           :bigint
#
require 'rails_helper'

RSpec.describe OpdBidang, type: :model do
  context 'opd bidang belongs to opd' do
    it { should belong_to :opd }
  end

  context 'opd bidang has many users' do
    it { should have_many :users }
  end
end
