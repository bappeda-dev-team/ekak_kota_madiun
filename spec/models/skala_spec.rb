# == Schema Information
#
# Table name: skalas
#
#  id         :bigint           not null, primary key
#  jenis      :string
#  jenis_skor :string
#  kode_skala :string
#  pilihan    :string
#  skor       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Skala, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
