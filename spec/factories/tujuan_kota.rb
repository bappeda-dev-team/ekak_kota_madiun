# == Schema Information
#
# Table name: tujuan_kota
#
#  id          :bigint           not null, primary key
#  id_misi     :string
#  id_tujuan   :string
#  kode_tujuan :string
#  misi        :string
#  tahun_akhir :string
#  tahun_awal  :string
#  tujuan      :string
#  type        :string
#  visi        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  misi_id     :bigint
#  pohon_id    :bigint
#
# Indexes
#
#  index_tujuan_kota_on_id_tujuan  (id_tujuan) UNIQUE
#  index_tujuan_kota_on_misi_id    (misi_id)
#  index_tujuan_kota_on_pohon_id   (pohon_id)
#
# Foreign Keys
#
#  fk_rails_...  (misi_id => misis.id)
#  fk_rails_...  (pohon_id => pohons.id)
#
FactoryBot.define do
  factory :tujuan_kota do
    id_misi { "id_misi_test" }
    tahun_awal { "2020" }
    tahun_akhir { "2024" }
    id_tujuan { "id_tujuan_abc" }
    visi { "visi test" }
    misi { "misi test" }
    tujuan { "Tujuan Kota" }
    kode_tujuan { "kode_tujuan_kota" }
  end
end
