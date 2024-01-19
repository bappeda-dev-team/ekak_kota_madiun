class DataDukungCloner < Clowne::Cloner
  adapter :active_record

  finalize do |_source, record, tahun:, tahun_asal:, **|
    record.tahun = tahun
    record.keterangan = "clone_#{tahun_asal}"
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
