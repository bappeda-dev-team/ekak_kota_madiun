# == Schema Information
#
# Table name: usulan_perangkat_daerahs
#
#  id                    :bigint           not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  isu_strategis_kota_id :integer
#  perangkat_daerah_id   :integer
#  strategi_kota_id      :integer
#
require 'rails_helper'

RSpec.describe UsulanPerangkatDaerah, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
