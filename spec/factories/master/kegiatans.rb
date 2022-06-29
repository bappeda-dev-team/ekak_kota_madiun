# == Schema Information
#
# Table name: master_kegiatans
#
#  id               :bigint           not null, primary key
#  id_bidang_urusan :string
#  id_kegiatan_sipd :string
#  id_program       :string
#  id_unik_sipd     :string           not null
#  id_urusan        :string
#  kode_giat        :string
#  nama_giat        :string           default("-")
#  no_giat          :string
#  tahun            :string           default("2022")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_master_kegiatans_on_id_unik_sipd  (id_unik_sipd) UNIQUE
#
FactoryBot.define do
  factory :master_kegiatan, class: 'Master::Kegiatan' do
    
  end
end
