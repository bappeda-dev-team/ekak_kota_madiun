# == Schema Information
#
# Table name: rincians
#
#  id                  :bigint           not null, primary key
#  dampak              :string
#  data_terpilah       :string
#  lokasi_pelaksanaan  :string
#  penyebab_external   :string
#  penyebab_internal   :string
#  permasalahan_gender :string
#  permasalahan_umum   :string
#  resiko              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  sasaran_id          :bigint           not null
#
# Indexes
#
#  index_rincians_on_sasaran_id  (sasaran_id)
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#
class Rincian < ApplicationRecord
  has_many :kesenjangans
  belongs_to :sasaran, optional: true
  # validates :lokasi_pelaksanaan, presence: true
  has_one :skala_dampak, class_name: 'Dampak'
  has_one :kemungkinan
  def lengkap
    data_terpilah.exists? && lokasi_pelaksanaan.exists?
  end

  def peta_resiko
    # [kemungkinan, dampak], x: kemungkinan, y: dampak
    matrik = [kemungkinan.nilai.to_i, skala_dampak.nilai.to_i]
    nilai = matrix_resiko.select { |_nilai, skor| skor.include?(matrik) }
    nilai.key(nilai.values.flatten(1)).to_s
  rescue NoMethodError
    '-'
  end

  def nilai_peta_resiko
    case peta_resiko
    when 'A'
      'Level Risiko Sangat Rendah'
    when 'B'
      'Level Risiko Rendah'
    when 'C'
      'Level Risiko Tinggi'
    when 'D'
      'Level Risiko Sangat Sangat Tinggi'
    else
      '-'
    end
  end

  def matrix_resiko
    { A: [[1, 1]],
      B: [[1, 2], [2, 1], [2, 2], [3, 1], [1, 3]],
      C: [[2, 3], [3, 2], [4, 1], [1, 4]],
      D: [[4, 2], [2, 4], [3, 4]] }
  end
end
