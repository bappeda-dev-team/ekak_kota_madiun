class CsvImportService
  require 'csv'

  def call(file)
    opened_file = file.open
    options = { headers: true, col_sep: ';' }
    CSV.foreach(opened_file, **options) do |row|
      # map the CSV columns to your database columns
      indikator_hash = {}
      indikator_hash[:indikator] = row['indikator']
      indikator_hash[:jenis] = row['jenis']
      indikator_hash[:sub_jenis] = row['sub_jenis']
      indikator_hash[:rumus_perhitungan] = row['rumus_perhitungan']
      indikator_hash[:sumber_data] = row['sumber_data']
      indikator_hash[:tahun] = row['tahun']
      indikator_hash[:kode_opd] = row['kode_opd_pelaksana']
      indikator_hash[:target] = row['target']
      indikator_hash[:satuan] = row['satuan']

      indikator = Indikator.create(indikator_hash)
      return indikator.errors unless indikator.save

      target_hash = {}
      target_hash[:target] = row['target']
      target_hash[:satuan] = row['satuan']
      target_hash[:tahun] = row['tahun']

      target = indikator.targets.create(target_hash)
      target.save

      # for performance, you could create a separate job to import each user
      # CsvImportJob.perform_later(user_hash)
    end
  end
end
