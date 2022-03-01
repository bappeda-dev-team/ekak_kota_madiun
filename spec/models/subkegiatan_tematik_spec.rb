# == Schema Information
#
# Table name: subkegiatan_tematiks
#
#  id           :bigint           not null, primary key
#  kode_tematik :string
#  nama_tematik :string
#  tahun        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe SubkegiatanTematik, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
