# == Schema Information
#
# Table name: anggota_tims
#
#  id         :bigint           not null, primary key
#  keterangan :string
#  metadata   :jsonb
#  nama       :string
#  role       :string
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tim_id     :bigint           not null
#
# Indexes
#
#  index_anggota_tims_on_tim_id  (tim_id)
#
# Foreign Keys
#
#  fk_rails_...  (tim_id => tims.id)
#
require 'rails_helper'

RSpec.describe AnggotaTim, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
