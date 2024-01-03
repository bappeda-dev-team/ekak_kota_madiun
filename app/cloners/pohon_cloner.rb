class PohonCloner < Clowne::Cloner
  adapter :active_record

  trait :with_strategi do
    include_association :strategis, params: true, traits: %i[just_strategi]
  end

  trait :with_strategi_sasaran do
    include_association :strategis, params: true, traits: %i[with_sasaran]
  end

  trait :pohon_tematik do
    include_association :sub_pohons, params: true, traits: %i[pohon_tematik]
    finalize do |source, record, tahun:, pohon_ref_id:, keterangan:, **|
      record.created_at = Time.current
      record.updated_at = Time.current
      record.tahun = tahun
      record.pohon_ref_id = pohon_ref_id
      record.keterangan = keterangan
      record.metadata = { cloned_from: source.id, cloned_at: Time.current }
    end
  end

  trait :pohon_no_sub do
    finalize do |source, record, tahun:, pohon_ref_id:, pohonable_id:, **|
      record.created_at = Time.current
      record.updated_at = Time.current
      record.tahun = tahun
      record.pohon_ref_id = pohon_ref_id
      record.pohonable_id = pohonable_id
      record.metadata = { cloned_from: source.id, cloned_at: Time.current }
    end
  end

  finalize do |_source, record, tahun:, **_params|
    record.created_at = Time.current
    record.updated_at = Time.current
    record.tahun = tahun
  end
end
