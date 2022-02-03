# == Schema Information
#
# Table name: anggarans
#
#  id         :bigint           not null, primary key
#  kode_rek   :string
#  uraian     :text
#  jumlah     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tahapan_id :bigint
#  level      :integer          default(0)
#  parent_id  :bigint
#  pajak_id   :bigint
#
require 'rails_helper'

RSpec.describe Anggaran, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
