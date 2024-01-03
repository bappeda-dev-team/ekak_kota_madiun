class TematikCloner < Clowne::Cloner
  adapter :active_record
  include_association :indikators
  nullify :tematik_ref_id

  finalize do |_source, record, tahun:, **_params|
    record.created_at = Time.current
    record.updated_at = Time.current
    record.tahun = tahun
  end
end
