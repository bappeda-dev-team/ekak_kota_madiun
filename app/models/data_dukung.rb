# == Schema Information
#
# Table name: data_dukungs
#
#  id                   :bigint           not null, primary key
#  data_dukungable_type :string
#  keterangan           :string
#  nama_data            :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  data_dukungable_id   :bigint
#
# Indexes
#
#  index_data_dukungs_on_data_dukungable  (data_dukungable_type,data_dukungable_id)
#
class DataDukung < ApplicationRecord
  belongs_to :data_dukungable, polymorphic: true

  validates :nama_data, presence: true

  def to_s
    nama_data
  end
end
