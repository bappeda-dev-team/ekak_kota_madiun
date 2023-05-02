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

  trait :per_opd do
    include_association :strategi_kotums, params: true, traits: [:per_opd]
  end

  trait :all_opd do
    include_association :strategi_kotums, params: true, traits: [:all_opd]
  end

  finalize do |source, record, tahun:, tahun_asal:, **|
    record.kode = "#{source.kode}_#{tahun}"
    record.tahun = tahun
    record.keterangan = "clone_#{tahun_asal}"
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
