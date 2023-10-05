class AksiCloner < Clowne::Cloner
  adapter :active_record

  # id_rencana_aksi
  # id_aksi_bulan == id_rencana_aksi
  nullify :id_rencana_aksi
  nullify :id_aksi_bulan

  finalize do |_source, record, tahun:, id_rencana_aksi:, **|
    record.keterangan = "cloned_#{tahun}"
    record.id_rencana_aksi = id_rencana_aksi
    record.id_aksi_bulan = SecureRandom.base36(6)
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
