class SubTematikCloner < Clowne::Cloner
  adapter :active_record
  include_association :indikators
  nullify :tematik_ref_id

  finalize do |_source, record, tahun:, tematik_ref_id:, **_params|
    record.created_at = Time.current
    record.updated_at = Time.current
    record.tahun = tahun
    record.tematik_ref_id = tematik_ref_id
  end
end
