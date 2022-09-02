# == Schema Information
#
# Table name: indikators
#
#  id             :bigint           not null, primary key
#  indikator      :string
#  jenis          :string
#  kode           :string
#  kode_indikator :string
#  pagu           :string           default("0")
#  satuan         :string
#  sub_jenis      :string
#  tahun          :string
#  target         :string
#
require 'rails_helper'

RSpec.describe Indikator, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
