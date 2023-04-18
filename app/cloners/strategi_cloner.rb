class StrategiCloner < Clowne::Cloner
  adapter :active_record

  # include_association :sasaran, params: true
  include_associations :strategi_eselon_tigas, :strategi_eselon_empats, :strategi_staffs

  finalize do |_source, record, **params|
    record.tahun = params[:tahun]
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
