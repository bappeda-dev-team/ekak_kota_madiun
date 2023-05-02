class PohonCloner < Clowne::Cloner
  adapter :active_record

  trait :with_strategi do
    include_association :strategis, params: true, traits: %i[just_strategi]
  end

  trait :with_strategi_sasaran do
    include_association :strategis, params: true, traits: %i[with_sasaran]
  end

  finalize do |_source, record, **|
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
