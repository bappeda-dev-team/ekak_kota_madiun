# == Schema Information
#
# Table name: tims
#
#  id          :bigint           not null, primary key
#  jabatan     :string
#  jenis       :string
#  keterangan  :string
#  nama_tim    :string
#  nip         :string
#  tahun       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  opd_id      :bigint
#  team_ref_id :bigint
#
# Indexes
#
#  index_tims_on_opd_id  (opd_id)
#
FactoryBot.define do
  factory :tim do
    nama_tim { "MyString" }
    nip { "MyString" }
    jabatan { "MyString" }
    opd { nil }
    keterangan { "MyString" }
    tahun { "" }
    jenis { "MyString" }
    team_ref_id { "" }
  end
end
