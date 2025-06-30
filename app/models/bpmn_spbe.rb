# == Schema Information
#
# Table name: bpmn_spbes
#
#  id                      :bigint           not null, primary key
#  dapat_digunakan_pd_lain :boolean          default(FALSE)
#  keterangan              :string
#  kode_opd                :string
#  nama_bpmn               :string
#  tahun                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
class BpmnSpbe < ApplicationRecord
  has_many :sasarans

  def to_s
    nama_bpmn
  end
end
