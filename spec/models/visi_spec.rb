# == Schema Information
#
# Table name: visis
#
#  id          :bigint           not null, primary key
#  keterangan  :string
#  tahun_akhir :string
#  tahun_awal  :string
#  urutan      :integer          default(1)
#  visi        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  lembaga_id  :bigint           not null
#
# Indexes
#
#  index_visis_on_lembaga_id  (lembaga_id)
#
# Foreign Keys
#
#  fk_rails_...  (lembaga_id => lembagas.id)
#
require 'rails_helper'

RSpec.describe Visi, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
