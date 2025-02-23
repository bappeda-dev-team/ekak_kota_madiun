# == Schema Information
#
# Table name: program_unggulans
#
#  id          :bigint           not null, primary key
#  asta_karya  :string
#  keterangan  :string
#  tahun_akhir :string
#  tahun_awal  :string
#  urutan      :integer          default(1)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  lembaga_id  :bigint           not null
#
# Indexes
#
#  index_program_unggulans_on_lembaga_id  (lembaga_id)
#
# Foreign Keys
#
#  fk_rails_...  (lembaga_id => lembagas.id)
#
FactoryBot.define do
  factory :program_unggulan do
    asta_karya { "Madiun Kota Pintar" }
    tahun_awal { "2025" }
    tahun_akhir { "2030" }
    urutan { 1 }
    keterangan { "Test" }
    association :lembaga
  end
end
