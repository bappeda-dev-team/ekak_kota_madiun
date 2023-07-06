# == Schema Information
#
# Table name: subdomains
#
#  id             :bigint           not null, primary key
#  keterangan     :string
#  kode_subdomain :string
#  subdomain      :string
#  tahun          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  domain_id      :bigint
#
# Indexes
#
#  index_subdomains_on_domain_id  (domain_id)
#
# Foreign Keys
#
#  fk_rails_...  (domain_id => domains.id)
#
FactoryBot.define do
  factory :subdomain do
    subdomain { "MyString" }
    domain { nil }
    kode_subdomain { "MyString" }
    keterangan { "MyString" }
    tahun { "MyString" }
  end
end
