# == Schema Information
#
# Table name: pagu_anggarans
#
#  id               :bigint           not null, primary key
#  anggaran         :decimal(, )
#  jenis            :string
#  keterangan       :string
#  kode             :string
#  kode_belanja     :string
#  kode_opd         :string
#  kode_sub_belanja :string
#  sub_jenis        :string
#  tahun            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe PaguAnggaran, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
