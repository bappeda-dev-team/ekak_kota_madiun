# == Schema Information
#
# Table name: pendidikans
#
#  id         :bigint           not null, primary key
#  jumlah     :integer
#  keterangan :string
#  pendidikan :string
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  jabatan_id :bigint           not null
#  opd_id     :bigint
#
# Indexes
#
#  index_pendidikans_on_jabatan_id  (jabatan_id)
#  index_pendidikans_on_opd_id      (opd_id)
#
# Foreign Keys
#
#  fk_rails_...  (jabatan_id => jabatans.id)
#
class Pendidikan < ApplicationRecord
  belongs_to :jabatan
  belongs_to :opd
end
