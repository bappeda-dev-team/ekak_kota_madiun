class IndikatorSasaranCloner < Clowne::Cloner
  adapter :active_record

  include_association :manual_ik, trait: :no_budget, clone_with: ManualIkCloner

  finalize do |_source, record, **|
    record.keterangan = "cloned"
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
