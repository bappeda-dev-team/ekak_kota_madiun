# == Schema Information
#
# Table name: mandatoris
#
#  id                :bigint           not null, primary key
#  is_active         :boolean          default(FALSE)
#  nip_asn           :string
#  opd               :string
#  peraturan_terkait :string
#  status            :enum             default("draft")
#  tahun             :string
#  uraian            :string
#  urutan            :integer          default(1), not null
#  usulan            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  sasaran_id        :bigint
#
# Indexes
#
#  index_mandatoris_on_sasaran_id  (sasaran_id)
#  index_mandatoris_on_status      (status)
#
FactoryBot.define do
  factory :mandatori do
    usulan { "Usulan Mandatori" }
    peraturan_terkait { "Peraturan Mandatori yang dibuat" }
    nip_asn { "123" }
  end
end
