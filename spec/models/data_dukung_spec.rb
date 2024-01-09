# == Schema Information
#
# Table name: data_dukungs
#
#  id                   :bigint           not null, primary key
#  data_dukungable_type :string
#  jumlah               :integer
#  keterangan           :string
#  nama_data            :string
#  satuan               :string
#  tahun                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  data_dukungable_id   :bigint
#
# Indexes
#
#  index_data_dukungs_on_data_dukungable  (data_dukungable_type,data_dukungable_id)
#
require 'rails_helper'

RSpec.describe DataDukung, type: :model do
  it { should validate_presence_of :nama_data }
end
