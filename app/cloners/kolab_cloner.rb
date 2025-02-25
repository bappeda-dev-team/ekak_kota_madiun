class KolabCloner < Clowne::Cloner
  adapter :active_record

  finalize do |_source, record, kolabable_id:, tahun:, **|
    record.created_at = Time.current
    record.updated_at = Time.current
    record.kolabable_id = kolabable_id
    record.tahun = tahun
  end
end
