class StrategiCloner < Clowne::Cloner
  adapter :active_record

  include_association :sasaran, params: true
  include_association :strategi_eselon_tigas, params: true
  include_association :strategi_eselon_empats, params: true
  include_association :strategi_staffs, params: true

  finalize do |_source, record, tahun:, **|
    record.tahun = tahun
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
