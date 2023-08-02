# == Schema Information
#
# Table name: tematiks
#
#  id             :bigint           not null, primary key
#  keterangan     :string
#  tema           :string
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tematik_ref_id :bigint
#
require 'rails_helper'

RSpec.describe Tematik, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
