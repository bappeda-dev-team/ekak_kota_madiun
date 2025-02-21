# == Schema Information
#
# Table name: kolabs
#
#  id             :bigint           not null, primary key
#  jenis          :string
#  keterangan     :string
#  kode_unik_opd  :string
#  kolabable_type :string
#  status         :string
#  tahun          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  kolabable_id   :bigint
#
require 'rails_helper'

RSpec.describe Kolab, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
