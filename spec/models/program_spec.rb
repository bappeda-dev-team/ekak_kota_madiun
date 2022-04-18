# == Schema Information
#
# Table name: programs
#
#  id                 :bigint           not null, primary key
#  id_program         :string
#  id_unik            :string
#  indikator          :string
#  kode_program       :string
#  nama_bidang_urusan :string
#  nama_program       :string
#  nama_urusan        :string
#  satuan             :string
#  tahun              :string
#  target             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require 'rails_helper'

RSpec.describe Program, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
