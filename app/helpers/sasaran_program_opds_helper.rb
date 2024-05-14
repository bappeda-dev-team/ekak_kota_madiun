module SasaranProgramOpdsHelper
  def peta_resiko(kemungkinan, skala_dampak)
    matrix_resiko =
      { A: [[1, 1]],
        B: [[1, 2], [1, 3], [2, 1], [2, 2], [3, 1]],
        C: [[1, 4], [2, 3], [3, 2], [4, 1], [3, 3]],
        D: [[2, 4], [3, 4], [4, 2], [4, 4]] }
    matrik = [kemungkinan.to_i, skala_dampak.to_i]
    nilai = matrix_resiko.select { |_nilai, skor| skor.include?(matrik) }
    nilai.key(nilai.values.flatten(1)).to_s
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
end
