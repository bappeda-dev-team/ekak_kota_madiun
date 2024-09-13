class TahapanCloner < Clowne::Cloner
  adapter :active_record

  # include_association :anggarans

  trait :normal do
    nullify :id_rencana_aksi
    nullify :jumlah_target
    nullify :waktu
  end

  finalize do |_source, record, id_rencana_sas:, **|
    record.id_rencana = id_rencana_sas
    record.id_rencana_aksi = SecureRandom.base36(6)
    record.target = 0
    record.jumlah_target = 0
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
