# == Schema Information
#
# Table name: perhitungans
#
#  id          :bigint           not null, primary key
#  volume      :integer
#  satuan      :string
#  harga       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  anggaran_id :bigint
#  total       :integer
#  deskripsi   :string
#
require 'rails_helper'

RSpec.describe Perhitungan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
