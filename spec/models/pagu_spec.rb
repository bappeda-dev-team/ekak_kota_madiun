# == Schema Information
#
# Table name: pagus
#
#  id         :bigint           not null, primary key
#  item       :string
#  satuan     :string
#  tipe       :string
#  total      :integer
#  uang       :integer
#  volume     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sasaran_id :bigint           not null
#
# Indexes
#
#  index_pagus_on_sasaran_id  (sasaran_id)
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#
require 'rails_helper'

RSpec.describe Pagu, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
