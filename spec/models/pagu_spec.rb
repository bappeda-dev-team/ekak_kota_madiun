# == Schema Information
#
# Table name: pagus
#
#  id         :bigint           not null, primary key
#  item       :string
#  uang       :integer
#  tipe       :string
#  satuan     :string
#  volume     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sasaran_id :bigint           not null
#  total      :integer
#
require 'rails_helper'

RSpec.describe Pagu, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
