# == Schema Information
#
# Table name: aksis
#
#  id         :bigint           not null, primary key
#  target     :integer
#  realisasi  :integer
#  bulan      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tahapan_id :bigint
#
require 'rails_helper'

RSpec.describe Aksi, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
