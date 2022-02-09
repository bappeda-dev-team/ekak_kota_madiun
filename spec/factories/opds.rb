# == Schema Information
#
# Table name: opds
#
#  id         :bigint           not null, primary key
#  kode_opd   :string
#  nama_opd   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lembaga_id :integer
#
FactoryBot.define do
  factory :opd do
    nama_opd { "Dinas Komunikasi dan Informatika" }
    kode_opd { "2.16.2.20.2.21.04.000" }
    association :lembaga
  end
end
