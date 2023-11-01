# == Schema Information
#
# Table name: external_urls
#
#  id         :bigint           not null, primary key
#  aplikasi   :string
#  endpoint   :text
#  keterangan :string
#  kode       :string
#  password   :string
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_external_urls_on_kode  (kode) UNIQUE
#
class ExternalUrl < ApplicationRecord
  validates :endpoint, presence: true
  validates :aplikasi, presence: true

  def to_s
    endpoint
  end
end
