# == Schema Information
#
# Table name: perhitungans
#
#  id          :bigint           not null, primary key
#  deskripsi   :string
#  harga       :integer
#  satuan      :string
#  spesifikasi :text
#  total       :integer
#  volume      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  anggaran_id :bigint
#  pajak_id    :bigint
#
# Indexes
#
#  index_perhitungans_on_anggaran_id  (anggaran_id)
#
# Foreign Keys
#
#  fk_rails_...  (pajak_id => pajaks.id) ON DELETE => nullify
#
FactoryBot.define do
  factory :perhitungan do
    deskripsi { '1.1.7.01.01.01.002' }
    satuan { 'Orang' }
    harga { 1_000_000 }
    association :anggaran
    factory :perhitungan_with_koefisiens do
      transient do
        koefisiens_count { 1 }
      end
      after(:create) do |perhitungan, evaluator|
        create_list(:koefisien, evaluator.koefisiens_count, perhitungan: perhitungan)
      end
    end
  end
end