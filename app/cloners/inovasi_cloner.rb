class InovasiCloner < Clowne::Cloner
  adapter :active_record

  nullify :sasaran_id

  finalize do |_source, record, tahun:, **|
    record.created_at = Time.current
    record.updated_at = Time.current
    record.tahun = tahun
    record.status = 'aktif'
    record.is_active = true
  end
end
