# == Schema Information
#
# Table name: inovasi_tims
#
#  id              :bigint           not null, primary key
#  jenis_inovasi   :string
#  nama_inovasi    :string
#  nilai_kebaruan  :string
#  tahun           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  crosscutting_id :bigint           not null
#
# Indexes
#
#  index_inovasi_tims_on_crosscutting_id  (crosscutting_id)
#
# Foreign Keys
#
#  fk_rails_...  (crosscutting_id => crosscuttings.id)
#
class InovasiTim < ApplicationRecord
  belongs_to :crosscutting
end
