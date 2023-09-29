class TahapanCloner < Clowne::Cloner
  adapter :active_record

  include_association :anggarans
  exclude_association :aksis

  nullify :id_rencana_aksi
  nullify :jumlah_target
  nullify :waktu

  finalize do |_source, record, tahun:, **|
    record.keterangan = "cloned_#{tahun}"
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
