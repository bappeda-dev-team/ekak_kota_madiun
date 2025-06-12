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

  def import_user(file_path)
    imported_count = 0
    updated_count = 0
    default_email_host = "madiunkota.go.id"
    options = { headers: true, col_sep: ';' }

    users_to_create = []
    failed_rows = []
    errors = []

    CSV.foreach(file_path, **options).with_index(1) do |row, index|
      nip = row['nip']
      email = "#{nip}@#{default_email_host}"
      user_roles = parse_roles(row['roles'])

      user = User.find_or_initialize_by(nik: nip.presence || row['nik']) do |u|
        u.email = email
      end

      # Set/update fields
      user.nama = row[0]
      user.jabatan = row['jabatan']
      user.kode_opd = row['kode_opd']
      user.password = row['password']
      user.password_confirmation = row['password']

      if user.valid?
        if user.persisted?
          user.save!(validate: false)
          updated_count += 1
        else
          users_to_create << { user: user, roles: user_roles }
        end
        assign_roles(user, user_roles)
      else
        errors << { row: index, messages: user.errors.full_messages }
        failed_rows << row.to_h
      end
    rescue StandardError => e
      errors << { row: index, messages: ["Unexpected error: #{e.message}"] }
      failed_rows << row.to_h
    end

    # Bulk import users yang baru
    if users_to_create.any?
      new_users = users_to_create.map { |u| u[:user] }
      result = User.import new_users, validate: false
      imported_count = result.num_inserts

      # Assign roles ke user yang baru
      users_to_create.each do |entry|
        entry[:user].add_role(*entry[:roles])
      end
    end

    log_errors(errors) if errors.any?

    {
      jumlah_baru: imported_count,
      jumlah_update: updated_count,
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

  def parse_roles(role_field)
    JSON.parse(role_field)
  rescue StandardError
    [role_field.to_s.strip]
  end

  def assign_roles(user, roles)
    # hapus yang lama
    user.roles.each { |r| user.remove_role(r.name) }
    # add yang baru
    roles.flatten.each { |r| user.add_role(r.to_sym) }
  end
end
