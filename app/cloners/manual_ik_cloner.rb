class ManualIkCloner < Clowne::Cloner
  adapter :active_record

  trait :no_budget do
    nullify :budget
  end

  finalize do |_source, record, **|
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
