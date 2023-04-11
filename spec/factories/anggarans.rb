# == Schema Information
#
# Table name: anggarans
#
#  id         :bigint           not null, primary key
#  jumlah     :decimal(, )
#  kode_rek   :string
#  level      :integer          default(0)
#  set_input  :string           default("0")
#  tahun      :integer
#  uraian     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pajak_id   :bigint
#  parent_id  :bigint
#  tahapan_id :bigint
#
# Indexes
#
#  index_anggarans_on_pajak_id    (pajak_id)
#  index_anggarans_on_parent_id   (parent_id)
#  index_anggarans_on_tahapan_id  (tahapan_id)
#
# Foreign Keys
#
#  fk_rails_...  (pajak_id => pajaks.id)
#
FactoryBot.define do
  factory :anggaran do
    kode_rek { "5.1.01.03.07.0001" }
    uraian { "Belanja Honorarium Penanggungjawaban Pengelola Keuangan" }
    level { 4 }
    association :tahapan
    association :pajak
    jumlah { 0 }
  end
end
