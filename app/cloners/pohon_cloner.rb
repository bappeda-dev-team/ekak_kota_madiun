class PohonCloner < Clowne::Cloner
  adapter :active_record

  include_association :strategis, params: true

  finalize do |_source, record, **|
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
