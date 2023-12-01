# == Schema Information
#
# Table name: manual_iks
#
#  id                   :bigint           not null, primary key
#  akhir                :string
#  budget               :string
#  definisi             :string
#  formula              :string
#  indikator_kinerja    :string
#  jenis_indikator      :string
#  jenis_output         :string
#  key_activities       :string
#  key_milestone        :string
#  mulai                :string
#  penanggung_jawab     :string
#  penyedia_data        :string
#  periode_pelaporan    :string
#  perspektif           :string
#  rhk                  :string
#  satuan               :string
#  sumber_data          :string
#  target               :string
#  tujuan_rhk           :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  indikator_sasaran_id :string
#
FactoryBot.define do
  factory :manual_ik do
    perspektif { "MyString" }
    rhk { "MyString" }
    tujuan_rhk { "MyString" }
    indikator_kinerja { "MyString" }
    target { "MyString" }
    satuan { "MyString" }
    definisi { "MyString" }
    key_activities { "MyString" }
    key_milestone { "MyString" }
    formula { "MyString" }
    jenis_indikator { "MyString" }
    penanggung_jawab { "MyString" }
    penyedia_data { "MyString" }
    sumber_data { "MyString" }
    mulai { "MyString" }
    akhir { "MyString" }
    periode_pelaporan { "MyString" }
    budget { "MyString" }
  end
end
