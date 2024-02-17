# == Schema Information
#
# Table name: jenis_jabatans
#
#  id         :bigint           not null, primary key
#  keterangan :string
#  nama_jenis :string           default("Jabatan Fungsional"), not null
#  nilai      :integer          default(3), not null
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe JenisJabatan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
