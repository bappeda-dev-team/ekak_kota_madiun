# == Schema Information
#
# Table name: spbes
#
#  id                  :bigint           not null, primary key
#  jenis_pelayanan     :string
#  kode_opd            :string
#  kode_program        :string
#  nama_aplikasi       :string
#  output_aplikasi     :string
#  terintegrasi_dengan :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#  strategi_ref_id     :string
#
require 'rails_helper'

RSpec.describe Spbe, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
