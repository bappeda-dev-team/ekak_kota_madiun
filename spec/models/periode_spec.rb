# == Schema Information
#
# Table name: periodes
#
#  id          :bigint           not null, primary key
#  tahun_akhir :string
#  tahun_awal  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Periode, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
