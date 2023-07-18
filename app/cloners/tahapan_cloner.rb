class TahapanCloner < Clowne::Cloner
  adapter :active_record

  nullify :id_rencana_aksi
  include_association :anggarans

  finalize do |_source, record, tahun:, **|
    record.keterangan = "cloned_#{tahun}"
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
