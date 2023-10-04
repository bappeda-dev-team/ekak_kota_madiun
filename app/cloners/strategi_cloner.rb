class StrategiCloner < Clowne::Cloner
  adapter :active_record

  trait :strategi_pohon do
    include_association :indikators

    nullify :strategi_cascade_link
    nullify :strategi_ref_id
    nullify :linked_with
    nullify :metadata
    nullify :nip_asn
    nullify :nip_asn_sebelumnya
    nullify :pohon_id
    nullify :sasaran_id

    finalize do |_source, record, keterangan:, parent_id:, **|
      record.keterangan = keterangan
      record.strategi_ref_id = parent_id
    end
  end

  finalize do |_source, record, tahun:, **|
    record.tahun = tahun
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
