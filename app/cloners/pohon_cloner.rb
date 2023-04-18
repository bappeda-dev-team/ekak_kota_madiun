class PohonCloner < Clowne::Cloner
  adapter :active_record

  trait :with_strategi do
    include_association :strategis, params: true
  end

  finalize do |_source, record, **params|
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
