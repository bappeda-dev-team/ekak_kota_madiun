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
#
require 'rails_helper'

RSpec.describe Visi, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
