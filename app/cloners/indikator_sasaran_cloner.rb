class IndikatorSasaranCloner < Clowne::Cloner
  adapter :active_record

  include_association :manual_ik, trait: :no_budget, clone_with: ManualIkCloner

  finalize do |_source, record, tahun:, **args|
    sasaran_id = args[:sasaran_id]
    record.keterangan = "clone_#{sasaran_id}_#{tahun}"
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
