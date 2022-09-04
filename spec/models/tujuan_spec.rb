# == Schema Information
#
# Table name: tujuans
#
#  id            :bigint           not null, primary key
#  id_tujuan     :string           not null
#  kode_unik_opd :string
#  tujuan        :string
#  type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_tujuans_on_id_tujuan  (id_tujuan) UNIQUE
#
require 'rails_helper'

RSpec.describe Tujuan, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
