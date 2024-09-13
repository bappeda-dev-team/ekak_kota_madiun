class DasarHukumCloner < Clowne::Cloner
  adapter :active_record

  finalize do |_source, record, tahun:, **args|
    sasaran_id = args[:sasaran_id]
    record.keterangan = "clone_#{sasaran_id}_#{tahun}"
    record.tahun = tahun
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
