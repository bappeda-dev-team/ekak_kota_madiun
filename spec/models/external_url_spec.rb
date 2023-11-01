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
require 'rails_helper'

RSpec.describe ExternalUrl, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
