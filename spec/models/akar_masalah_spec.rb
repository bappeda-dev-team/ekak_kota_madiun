# == Schema Information
#
# Table name: akar_masalahs
#
#  id            :bigint           not null, primary key
#  akar_masalah  :string
#  kode_opd      :string
#  masalah       :string
#  masalah_pokok :string
#  tahun         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe AkarMasalah, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
