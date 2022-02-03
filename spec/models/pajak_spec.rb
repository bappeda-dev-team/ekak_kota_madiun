# == Schema Information
#
# Table name: pajaks
#
#  id         :bigint           not null, primary key
#  tahun      :string
#  tipe       :string
#  potongan   :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Pajak, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
