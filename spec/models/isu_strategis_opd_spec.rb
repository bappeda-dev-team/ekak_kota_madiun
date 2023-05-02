# == Schema Information
#
# Table name: isu_strategis_opds
#
#  id            :bigint           not null, primary key
#  isu_strategis :string           not null
#  keterangan    :string
#  kode          :string           not null
#  kode_opd      :string           not null
#  tahun         :string           not null
#  tujuan        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe IsuStrategisOpd, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
