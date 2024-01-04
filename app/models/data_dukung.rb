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
class DataDukung < ApplicationRecord
  validates :nama_data, presence: true
end
