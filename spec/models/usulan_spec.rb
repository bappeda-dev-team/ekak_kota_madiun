# == Schema Information
#
# Table name: usulans
#
#  id              :bigint           not null, primary key
#  keterangan      :string
#  usulanable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  usulanable_id   :bigint
#
# Indexes
#
#  index_usulans_on_usulanable  (usulanable_type,usulanable_id)
#
require 'rails_helper'

RSpec.describe Usulan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
