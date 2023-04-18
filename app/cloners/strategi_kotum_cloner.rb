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

  include_association :pohons, params: true

  finalize do |_source, record, **params|
    record.tahun = params[:tahun]
    record.created_at = Time.current
    record.updated_at = Time.current
  end
end
