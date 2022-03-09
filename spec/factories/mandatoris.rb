# == Schema Information
#
# Table name: mandatoris
#
#  id                :bigint           not null, primary key
#  is_active         :boolean          default(FALSE)
#  nip_asn           :string
#  opd               :string
#  peraturan_terkait :string
#  tahun             :string
#  usulan            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  sasaran_id        :bigint
#
# Indexes
#
#  index_mandatoris_on_sasaran_id  (sasaran_id)
#
FactoryBot.define do
  factory :mandatori do
    usulan { "MyString" }
    peraturan_terkait { "MyString" }
  end
end
