# == Schema Information
#
# Table name: bpmn_spbes
#
#  id                      :bigint           not null, primary key
#  dapat_digunakan_pd_lain :boolean          default(FALSE)
#  keterangan              :string
#  kode_opd                :string
#  nama_bpmn               :string
#  tahun                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
FactoryBot.define do
  factory :bpmn_spbe do
    nama_bpmn { "MyString" }
    kode_opd { "MyString" }
    tahun { "MyString" }
    keterangan { "MyString" }
  end
end
