class SasaranCloner < Clowne::Cloner
  adapter :active_record

  include_association :indikator_sasarans, params: true

  finalize do |source, record, tahun:, **|
    record.id_rencana = "#{source.id_rencana}_#{tahun}"
    record.tahun = tahun
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
