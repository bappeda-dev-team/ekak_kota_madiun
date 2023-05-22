class IsuStrategisOpdCloner < Clowne::Cloner
  adapter :active_record

  trait :per_opd do
    include_association :pohons,
                        ->(params) { where(opd_id: params[:opd_id]) },
                        params: true, traits: %i[with_strategi_sasaran]
  end

  finalize do |source, record, tahun:, tahun_asal:, **|
    record.kode = "#{source.kode}_#{tahun}"
    record.tahun = tahun
    record.keterangan = "clone_#{tahun_asal}"
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
