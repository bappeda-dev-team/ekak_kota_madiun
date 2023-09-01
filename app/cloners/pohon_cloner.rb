# == Schema Information
#
# Table name: pohons
#
#  id             :bigint           not null, primary key
#  keterangan     :string
#  metadata       :jsonb
#  pohonable_type :string
#  role           :string
#  status         :string
#  tahun          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  opd_id         :bigint
#  pohon_ref_id   :bigint
#  pohonable_id   :bigint
#  strategi_id    :bigint
#  user_id        :bigint
#
# Indexes
#
#  index_pohons_on_opd_id       (opd_id)
#  index_pohons_on_pohonable    (pohonable_type,pohonable_id)
#  index_pohons_on_strategi_id  (strategi_id)
#  index_pohons_on_user_id      (user_id)
#
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

  finalize do |_source, record, tahun:, **_params|
    record.created_at = Time.current
    record.updated_at = Time.current
    record.tahun = tahun
  end
end
