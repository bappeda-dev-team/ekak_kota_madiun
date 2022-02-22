# == Schema Information
#
# Table name: inovasis
#
#  id         :bigint           not null, primary key
#  manfaat    :string
#  usulan     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Inovasi, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
