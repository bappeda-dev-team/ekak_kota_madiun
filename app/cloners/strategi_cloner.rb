class StrategiCloner < Clowne::Cloner
  adapter :active_record

  trait :with_sasaran do
    include_association :sasaran, params: true, traits: %i[with_indikators]
    include_association :strategi_eselon_tigas, params: true, traits: :with_sasaran
    include_association :strategi_eselon_empats, params: true, traits: :with_sasaran
    include_association :strategi_staffs, params: true, traits: :with_sasaran
  end

  trait :with_sasarans_new do
    include_association :sasaran, params: true, traits: %i[pokin]
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

  trait :just_strategi do
    include_association :strategi_eselon_tigas, params: true, traits: :just_strategi
    include_association :strategi_eselon_empats, params: true, traits: :just_strategi
    include_association :strategi_staffs, params: true, traits: :just_strategi
  end

  # include_association :strategi_eselon_dua_bs, params: true, traits: :with_sasaran
  include_association :strategi_eselon_tigas, params: true, traits: :with_sasaran
  include_association :strategi_eselon_empats, params: true, traits: :with_sasaran
  include_association :strategi_staffs, params: true, traits: :with_sasaran

  finalize do |_source, record, tahun:, **|
    record.tahun = tahun
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
