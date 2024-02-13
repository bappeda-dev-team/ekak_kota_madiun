# == Schema Information
#
# Table name: jumlahs
#
#  id             :bigint           not null, primary key
#  jumlah         :decimal(, )
#  keterangan     :string
#  satuan         :string
#  tahun          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  data_dukung_id :bigint
#
# Indexes
#
#  index_jumlahs_on_data_dukung_id  (data_dukung_id)
#
class Jumlah < ApplicationRecord
  belongs_to :data_dukung
end
