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

  def import_user(file)
    imported_count = 0
    default_email_host = "madiunkota.go.id"
    opened_file = file.open
    options = { headers: true, col_sep: ';' }

    users = []
    failed_rows = []
    errors = []

    CSV.foreach(opened_file, **options).with_index(1) do |row, index|
      user_role = row['role']
      user = User.new(
        nama: row[0],
        nik: row['nip'],
        email: "#{row['nip']}@#{default_email_host}",
        jabatan: row['jabatan'],
        kode_opd: row['kode_opd'],
        password: row['password'],
        password_confirmation: row['password']
      )
      if user.valid?
        users << user
        user.add_role(user_role)
      else
        errors << { row: index, messages: user.errors.full_messages }
        failed_rows << row.to_h
      end
    end

    if users.any?
      result = User.import users, validate: false # Skip validation since we manually validated
      imported_count = result.num_inserts
    end

    log_errors(errors) if errors.any?

    {
      jumlah_berhasil: imported_count,
      jumlah_gagal: failed_rows.size,
      errors: errors
    }
  end

  private

  def log_errors(errors)
    File.open("log/csv_import_errors.log", "a") do |file|
      file.puts "CSV Import Errors at #{Time.now}:"
      errors.each do |error|
        file.puts "Row #{error[:row]}: #{error[:messages].join(', ')}"
      end
      file.puts "----------------------------------------"
    end
  end
end
