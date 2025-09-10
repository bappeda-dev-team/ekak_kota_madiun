# == Schema Information
#
# Table name: detail_pegawais
#
#  id         :bigint           not null, primary key
#  nama       :string
#  nik_enc    :string
#  nip        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_detail_pegawais_on_nip  (nip) UNIQUE
#
class DetailPegawai < ApplicationRecord
  belongs_to :user, foreign_key: 'nip', primary_key: 'nik'
end
