# == Schema Information
#
# Table name: pks
#
#  id                :bigint           not null, primary key
#  sasaran           :string
#  indikator_kinerja :string
#  target            :string
#  satuan            :string
#  user_id           :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'rails_helper'

RSpec.describe Pk, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
