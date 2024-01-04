# == Schema Information
#
# Table name: data_dukungs
#
#  id         :bigint           not null, primary key
#  keterangan :string
#  nama_data  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe DataDukung, type: :model do
  it { should validate_presence_of :nama_data }
end
