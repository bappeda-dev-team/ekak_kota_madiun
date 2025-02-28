# == Schema Information
#
# Table name: program_unggulans
#
#  id          :bigint           not null, primary key
#  asta_karya  :string
#  kelompok    :string
#  keterangan  :string
#  tahun_akhir :string
#  tahun_awal  :string
#  urutan      :integer          default(1)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  lembaga_id  :bigint           not null
#
# Indexes
#
#  index_program_unggulans_on_lembaga_id  (lembaga_id)
#
# Foreign Keys
#
#  fk_rails_...  (lembaga_id => lembagas.id)
#
require 'rails_helper'

RSpec.describe ProgramUnggulan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
