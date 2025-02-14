# == Schema Information
#
# Table name: misis
#
#  id          :bigint           not null, primary key
#  keterangan  :string
#  misi        :string
#  tahun_akhir :string
#  tahun_awal  :string
#  urutan      :integer          default(1)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  visi_id     :bigint           not null
#
# Indexes
#
#  index_misis_on_visi_id  (visi_id)
#
# Foreign Keys
#
#  fk_rails_...  (visi_id => visis.id)
#
FactoryBot.define do
  factory :misi do
    misi { "MISI CONTOH" }
    urutan { 1 }
    keterangan { "-" }
    tahun_awal { "2025" }
    tahun_akhir { "2026" }
    association :visi
  end
end
