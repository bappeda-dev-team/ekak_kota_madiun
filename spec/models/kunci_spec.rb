# == Schema Information
#
# Table name: kuncis
#
#  id             :bigint           not null, primary key
#  dikunci_oleh   :string
#  jenis          :string
#  keterangan     :string
#  kode_opd       :string
#  kunciable_type :string
#  status_kunci   :string
#  tahun          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  kunciable_id   :bigint
#
# Indexes
#
#  index_kuncis_on_kunciable  (kunciable_type,kunciable_id)
#
require 'rails_helper'

RSpec.describe Kunci, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
