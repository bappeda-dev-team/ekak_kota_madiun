class IndikatorSasaranCloner < Clowne::Cloner
  adapter :active_record

  include_association :manual_ik, trait: :no_budget, clone_with: ManualIkCloner

  finalize do |_source, record, tahun:, **|
    record.keterangan = "cloned_#{tahun}"
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
