# == Schema Information
#
# Table name: crosscuttings
#
#  id                :bigint           not null, primary key
#  nama_instansi     :string
#  opd_pelaksana     :string
#  tipe_crosscutting :string
#  tipe_instansi     :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  strategi_id       :bigint           not null
#
# Indexes
#
#  index_crosscuttings_on_strategi_id  (strategi_id)
#
# Foreign Keys
#
#  fk_rails_...  (strategi_id => strategis.id)
#
require 'rails_helper'

RSpec.describe Crosscutting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
