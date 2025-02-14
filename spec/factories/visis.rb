# == Schema Information
#
# Table name: visis
#
#  id          :bigint           not null, primary key
#  keterangan  :string
#  tahun_akhir :string
#  tahun_awal  :string
#  urutan      :integer          default(1)
#  visi        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  lembaga_id  :bigint           not null
#
# Indexes
#
#  index_visis_on_lembaga_id  (lembaga_id)
#
# Foreign Keys
#
#  fk_rails_...  (lembaga_id => lembagas.id)
#
FactoryBot.define do
  factory :visi do
    visi { "VISI CONTOH" }
    urutan { 1 }
    keterangan { "-" }
    tahun_awal { "2025" }
    tahun_akhir { "2026" }
  end
end
