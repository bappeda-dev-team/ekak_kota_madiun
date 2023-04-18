class SasaranCloner < Clowne::Cloner
  adapter :active_record

  include_association :indikator_sasarans

  finalize do |_source, record, **params|
    record.tahun = params[:tahun]
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
