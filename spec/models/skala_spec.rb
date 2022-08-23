# == Schema Information
#
# Table name: skalas
#
#  id         :bigint           not null, primary key
#  deskripsi  :string
#  keterangan :string
#  kode_skala :string
#  nilai      :string
#  tipe_nilai :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rincian_id :bigint
#
# Indexes
#
#  index_skalas_on_rincian_id  (rincian_id)
#
require 'rails_helper'

RSpec.describe Skala, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
