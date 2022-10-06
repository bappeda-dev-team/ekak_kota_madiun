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
#  kemungkinan_id      :integer
#  sasaran_id          :bigint           not null
#  skala_id            :bigint
#
# Indexes
#
#  index_rincians_on_sasaran_id  (sasaran_id)
#  index_rincians_on_skala_id    (skala_id)
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#
class Rincian < ApplicationRecord
  has_many :kesenjangans
  belongs_to :sasaran, optional: true
  # validates :lokasi_pelaksanaan, presence: true
  belongs_to :skala_dampak, primary_key: 'id', foreign_key: 'skala_id', class_name: 'Dampak', optional: true
  belongs_to :kemungkinan, primary_key: 'id', foreign_key: 'kemungkinan_id', optional: true
  def lengkap
    data_terpilah.exists? && lokasi_pelaksanaan.exists?
  end

  def peta_resiko(nilai_kemungkinan, nilai_skala_dampak)
    # [kemungkinan, dampak], x: kemungkinan, y: dampak
    matrik = [nilai_kemungkinan.to_i, nilai_skala_dampak.to_i]
    nilai = matrix_resiko.select { |_nilai, skor| skor.include?(matrik) }
    nilai.key(nilai.values.flatten(1)).to_s
  rescue NoMethodError
    '-'
  end

  def nilai_peta_resiko(peta_matrix)
    case peta_matrix
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
