# == Schema Information
#
# Table name: kebutuhans
#
#  id         :bigint           not null, primary key
#  kebutuhan  :string
#  keterangan :string
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Kebutuhan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
