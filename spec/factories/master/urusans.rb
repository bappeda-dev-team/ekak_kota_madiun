# == Schema Information
#
# Table name: master_urusans
#
#  id             :bigint           not null, primary key
#  id_unik_sipd   :string           not null
#  id_urusan_sipd :string
#  kode_urusan    :string
#  nama_urusan    :string
#  tahun          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_master_urusans_on_id_unik_sipd  (id_unik_sipd) UNIQUE
#
FactoryBot.define do
  factory :master_urusan, class: 'Master::Urusan' do
    id_unik_sipd { "1.1" }
    kode_urusan { "2" }
    nama_urusan { "URUSAN PEMERINTAHAN WAJIB YANG TIDAK BERKAITAN DENGAN PELAYANAN DASAR" }
  end
end
