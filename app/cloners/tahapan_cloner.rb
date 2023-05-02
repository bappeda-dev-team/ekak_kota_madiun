class TahapanCloner < Clowne::Cloner
  adapter :active_record

  trait :normal do
    include_association :aksis
    include_association :anggarans
  end

  finalize do |source, record, tahun:, **|
    # record.id_rencana = "#{source.id_rencana}_#{tahun}"
    # record.id_rencana_aksi = "#{source.id_rencana}_#{tahun}"
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
