# == Schema Information
#
# Table name: jabatans
#
#  id            :bigint           not null, primary key
#  index         :string
#  kelas_jabatan :string
#  kode_jabatan  :string
#  kode_opd      :string
#  nama_jabatan  :string
#  nilai_jabatan :integer
#  tahun         :string
#  tipe          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe Jabatan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
