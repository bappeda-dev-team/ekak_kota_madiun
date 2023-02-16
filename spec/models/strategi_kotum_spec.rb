# == Schema Information
#
# Table name: strategi_kota
#
#  id                    :bigint           not null, primary key
#  strategi              :string
#  tahun                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  isu_strategis_kota_id :string
#  sasaran_kota_id       :string
#
require 'rails_helper'

RSpec.describe StrategiKotum, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
