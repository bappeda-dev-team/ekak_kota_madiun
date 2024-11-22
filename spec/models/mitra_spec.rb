# == Schema Information
#
# Table name: mitras
#
#  id                   :bigint           not null, primary key
#  jenis_mitra          :string
#  keterangan           :string
#  nama_kerjasama       :string
#  penjelasan_kerjasama :string
#  tahun_kerjasama      :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  crosscutting_id      :bigint           not null
#
# Indexes
#
#  index_mitras_on_crosscutting_id  (crosscutting_id)
#
# Foreign Keys
#
#  fk_rails_...  (crosscutting_id => crosscuttings.id)
#
require 'rails_helper'

RSpec.describe Mitra, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
