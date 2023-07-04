# == Schema Information
#
# Table name: tahuns
#
#  id         :bigint           not null, primary key
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  periode_id :bigint
#
require 'rails_helper'

RSpec.describe Tahun, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
