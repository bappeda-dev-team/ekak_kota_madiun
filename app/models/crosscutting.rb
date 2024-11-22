# == Schema Information
#
# Table name: crosscuttings
#
#  id                :bigint           not null, primary key
#  opd_pelaksana     :string
#  tipe_crosscutting :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  strategi_id       :bigint           not null
#
# Indexes
#
#  index_crosscuttings_on_strategi_id  (strategi_id)
#
# Foreign Keys
#
#  fk_rails_...  (strategi_id => strategis.id)
#
class Crosscutting < ApplicationRecord
  belongs_to :strategi
  has_many :mitras
  accepts_nested_attributes_for :mitras, allow_destroy: true

  def nama_opd_pelaksana
    Opd.find_by(kode_unik_opd: opd_pelaksana).nama_opd
  end
end
