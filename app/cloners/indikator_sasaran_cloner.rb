class IndikatorSasaranCloner < Clowne::Cloner
  adapter :active_record

  finalize do |source, record, **|
    record.sasaran_id = source.id_rencana
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
