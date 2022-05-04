# == Schema Information
#
# Table name: tematik_sasarans
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  sasaran_id             :bigint
#  subkegiatan_tematik_id :bigint
#
# Indexes
#
#  index_tematik_sasarans_on_sasaran_id              (sasaran_id)
#  index_tematik_sasarans_on_subkegiatan_tematik_id  (subkegiatan_tematik_id)
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#  fk_rails_...  (subkegiatan_tematik_id => subkegiatan_tematiks.id)
#
require 'rails_helper'

RSpec.describe TematikSasaran, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
