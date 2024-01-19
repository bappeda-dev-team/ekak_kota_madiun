class DataDukungCloner < Clowne::Cloner
  adapter :active_record

  include_association :jumlahs

  finalize do |_source, record, tahun:, **|
    record.tahun = tahun
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
