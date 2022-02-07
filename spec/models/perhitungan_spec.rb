# == Schema Information
#
# Table name: perhitungans
#
#  id          :bigint           not null, primary key
#  deskripsi   :string
#  harga       :integer
#  satuan      :string
#  total       :integer
#  volume      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  anggaran_id :bigint
#
# Indexes
#
#  index_perhitungans_on_anggaran_id  (anggaran_id)
#
require 'rails_helper'

RSpec.describe Perhitungan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
