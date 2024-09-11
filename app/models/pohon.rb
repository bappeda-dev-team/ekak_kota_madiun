# == Schema Information
#
# Table name: pohons
#
#  id                :bigint           not null, primary key
#  keterangan        :string
#  metadata          :jsonb
#  pohon_khusus      :boolean          default(FALSE)
#  pohonable_type    :string
#  role              :string
#  status            :string
#  tahun             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  opd_id            :bigint
#  pohon_ref_id      :bigint
#  pohonable_id      :bigint
#  strategi_id       :bigint
#  strategi_pohon_id :bigint
#  user_id           :bigint
#
# Indexes
#
#  index_pohons_on_opd_id       (opd_id)
#  index_pohons_on_pohonable    (pohonable_type,pohonable_id)
#  index_pohons_on_strategi_id  (strategi_id)
#  index_pohons_on_user_id      (user_id)
#
class Pohon < ApplicationRecord
  default_scope { order(:id) }
  belongs_to :pohonable, polymorphic: true
  belongs_to :opd, optional: true
  belongs_to :user, optional: true
  has_many :strategis, -> { where(strategis: { role: "eselon_2" }) }
  has_many :komentars, primary_key: :id, foreign_key: :item
  has_many :reviews, as: :reviewable

  has_many :sub_pohons, foreign_key: :pohon_ref_id, primary_key: :id, class_name: 'Pohon'
  belongs_to :parent_pohon, foreign_key: :pohon_ref_id, primary_key: :id, optional: true, class_name: 'Pohon'

  scope :pohon_opd, -> { where(pohonable_type: "IsuStrategisOpd") }
  scope :pohon_kota, -> { where(pohonable_type: "StrategiKotum") }

  store :metadata
  store_accessor :metadata, :tim_id, :role_tim, :processed_at,
                 :assigned_by, :keterangan_tim, :tahun_tim, :opd_tim

  def to_s
    pohonable.class.name.underscore.titleize
  end

  def isu_strategis_id
    if pohonable_type == 'IsuStrategisOpd'
      pohonable.id
    else
      pohonable.isu_strategis_kota_id.to_i
    end
  end

  def isu_strategis_disasar
    if pohonable_type == 'StrategiKotum'
      pohonable.nama_isu
    else
      pohonable.isu_strategis
    end
  end

  def strategi_kota_isu_strategis
    "Isu Strategis: #{keterangan} - Strategi Kota: #{pohonable.strategi}"
  end

  def strategi_kepala_by_opd
    strategis.pluck(:strategi).map.with_index(1) do |ss, no|
      "#{no}. #{ss}\n"
    end
  end

  def strategi_opd
    pohonable.strategi
  end

  def strategis_opd(_opd_id)
    strategis
  end

  def strategi
    keterangan
  end

  def nama_strategi
    pohonable.strategi.nil? ? 'tidak ditemukan' : pohonable.strategi
  end

  def indikators_tahun(_tahun)
    strategis.map(&:indikator_sasarans).flatten
  end

  def nama_pemilik
    user&.nama
  end

  def nip_asn
    user.nik
  end

  def linked_strategis
    Pohon.where(pohonable_type: 'Strategi', strategi_id: strategi_id, user_id: user_id)
  end

  def dibagikan_ke
    if user.present?
      user.nama
    else
      "#{opd.nama_opd} (External)"
    end
  end

  def sub_tema
    if pohonable.present?
      pohonable.tema
    else
      'Tidak Ditemukan'
    end
  end

  def id_strategi
    "#{id}-#{role}"
  end

  def judul_strategi
    "#{pohonable} #{'- Dari Kota' if role.include?('kota')}"
  end

  def id_strategi_parent
    "#{pohon_ref_id}-#{parent_pohon.role}"
  end

  def add_strategi_pohon(ref_id: '')
    strategi_new = pohonable.dup.attributes
    new_role = case role
               when 'strategi_pohon_kota'
                 'eselon_2'
               when 'tactical_pohon_kota'
                 'eselon_3'
               when 'operational_pohon_kota'
                 'eselon_4'
               else
                 'staff'
               end
    sp_new = StrategiPohon.new(strategi_new.merge(role: new_role,
                                                  tahun: tahun,
                                                  strategi_cascade_link: pohonable_id,
                                                  type: 'StrategiPohon',
                                                  strategi_ref_id: ref_id))
    sp_new.keterangan = '--dari kota--'
    sp_new.save

    pohonable.indikators.dup.each do |clones|
      clones.tap do |clone|
        clone.assign_attributes(jenis: 'StrategiPohon',
                                sub_jenis: 'StrategiPohon',
                                kode: sp_new.id)
      end.save
    end

    sp_new
  end

  def strategi_dari_kota_finder
    return if strategi_pohon_id.nil?

    StrategiPohon.find(strategi_pohon_id)
  end
end
