class StrategiCloner < Clowne::Cloner
  adapter :active_record

  trait :with_sasaran do
    include_association :indikator_sasarans, params: true
    include_association :strategi_eselon_tigas, params: true, traits: :with_sasaran
    include_association :strategi_eselon_empats, params: true, traits: :with_sasaran
    include_association :strategi_staffs, params: true, traits: :with_sasaran
  end

  trait :with_sasarans_new do
    include_association :indikator_sasarans, params: true
    include_association :strategi_eselon_tigas, params: true, traits: :with_sasarans_new
    include_association :strategi_eselon_empats, params: true, traits: :with_sasarans_new
    include_association :strategi_staffs, params: true, traits: :with_sasarans_new

    finalize do |_source, record, tahun:, **params|
      record.tahun = tahun
      record.created_at = Time.current
      record.updated_at = Time.current
      record.type = params[:type]
      record.nip_asn = params[:nip]
      record.strategi_cascade_link = params[:strategi_cascade_link]
      record.opd_id = params[:opd_id]
    end
  end

  trait :no_bawahan do
    include_association :indikator_sasarans, params: true
    exclude_association :strategi_eselon_tigas
    exclude_association :strategi_eselon_empats
    exclude_association :strategi_staffs

    finalize do |_source, record, tahun:, **params|
      record.tahun = tahun
      record.created_at = Time.current
      record.updated_at = Time.current
      record.type = 'StrategiPohon'
      record.nip_asn = ''
      record.strategi_cascade_link = params[:strategi_cascade_link]
      record.opd_id = params[:opd_id]
    end
  end

  trait :just_strategi do
    include_association :strategi_eselon_tigas, params: true, traits: :just_strategi
    include_association :strategi_eselon_empats, params: true, traits: :just_strategi
    include_association :strategi_staffs, params: true, traits: :just_strategi
  end

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

  # include_association :strategi_eselon_dua_bs, params: true, traits: :with_sasaran
  # include_association :strategi_eselon_tigas, params: true, traits: :with_sasaran
  # include_association :strategi_eselon_empats, params: true, traits: :with_sasaran
  # include_association :strategi_staffs, params: true, traits: :with_sasaran

  finalize do |_source, record, tahun:, **|
    record.tahun = tahun
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
