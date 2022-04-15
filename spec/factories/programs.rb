# == Schema Information
#
# Table name: programs
#
#  id                 :bigint           not null, primary key
#  id_program         :string
#  id_unik            :string
#  indikator          :string
#  kode_program       :string
#  nama_bidang_urusan :string
#  nama_program       :string
#  nama_urusan        :string
#  satuan             :string
#  tahun              :string
#  target             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :program do
    
  end
end
