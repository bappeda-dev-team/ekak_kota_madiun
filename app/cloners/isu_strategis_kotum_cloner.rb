# Table name: isu_strategis_kota
#
#  id            :bigint           not null, primary key
#  isu_strategis :string           not null
#  kode          :string           not null
#  tahun         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  lembaga_id    :bigint           default(1)
class IsuStrategisKotumCloner < Clowne::Cloner
  adapter :active_record

  include_association :strategi_kotums, params: true

  finalize do |source, record, **params|
    record.kode = "#{source.kode}_#{params[:tahun]}"
    record.tahun = params[:tahun]
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
