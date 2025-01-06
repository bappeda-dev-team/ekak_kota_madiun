# == Schema Information
#
# Table name: indikator_sasarans
#
#  id                :bigint           not null, primary key
#  aspek             :string
#  id_indikator      :string
#  indikator_kinerja :string
#  is_hidden         :boolean          default(FALSE), not null
#  keterangan        :string
#  satuan            :string
#  target            :string
#  type              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  sasaran_id        :string
#
# Indexes
#
#  index_indikator_sasarans_on_id_indikator  (id_indikator) UNIQUE
#
FactoryBot.define do
  factory :indikator_sasaran do
    indikator_kinerja { 'indikator-kinerja-1' }
    target { 10 }
    satuan { '%' }
    association :sasaran
  end
end
