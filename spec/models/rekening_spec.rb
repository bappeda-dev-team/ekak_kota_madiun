# == Schema Information
#
# Table name: rekenings
#
#  id             :bigint           not null, primary key
#  jenis_rekening :string
#  kode_rekening  :string
#  set_input      :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe Rekening, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
