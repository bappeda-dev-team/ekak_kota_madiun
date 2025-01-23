module SasaranProgramOpdsHelper
  def peta_resiko(kemungkinan, skala_dampak)
    matrix_resiko =
      { A: [[1, 1], [1, 2], [1, 3], [2, 1], [2, 2], [3, 1]],
        B: [[1, 4], [1, 5], [2, 3], [2, 4], [2, 5], [3, 2], [3, 3], [3, 4], [4, 1], [4, 2], [4, 3], [5, 1], [5, 2]],
        C: [[3, 5], [4, 4], [4, 5], [5, 3], [5, 4], [5, 5]] }
    matrik = [kemungkinan.to_i, skala_dampak.to_i]
    nilai = matrix_resiko.select { |_nilai, skor| skor.include?(matrik) }
    nilai.key(nilai.values.flatten(1)).to_s
  end

  def nilai_peta_resiko(peta_matrix)
    prefix = 'Level Risiko'
    case peta_matrix
    when 'A'
      "#{prefix} Rendah"
    when 'B'
      "#{prefix} Sedang"
    when 'C'
      "#{prefix} Sangat Tinggi"
    else
      '-'
    end
  end
end
