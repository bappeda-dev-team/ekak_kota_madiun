# Table name: strategi_kota
#
#  id                    :bigint           not null, primary key
#  strategi              :string
#  tahun                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  isu_strategis_kota_id :string
#  sasaran_kota_id       :string
#
class StrategiKotumCloner < Clowne::Cloner
  adapter :active_record

  trait :per_opd do
    include_association :pohons,
                        ->(params) { where(opd_id: params[:opd_id]) },
                        params: true, traits: %i[with_strategi_sasaran]
  end

  trait :all_opd do
    include_association :pohons, params: true, traits: %i[with_strategi_sasaran]
  end

  finalize do |_source, record, tahun:, tahun_asal:, **|
    record.tahun = tahun
    record.keterangan = "clone_#{tahun_asal}_to_#{tahun}"
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
