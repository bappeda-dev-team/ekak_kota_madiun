# == Schema Information
#
# Table name: genders
#
#  id                  :bigint           not null, primary key
#  akses               :string
#  data_terpilah       :string
#  indikator           :string
#  kontrol             :string
#  manfaat             :string
#  partisipasi         :string
#  penerima_manfaat    :string
#  penyebab_external   :string
#  penyebab_internal   :string
#  reformulasi_tujuan  :string
#  sasaran_subkegiatan :string
#  satuan              :string
#  target              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#  sasaran_id          :bigint
#
# Indexes
#
#  index_genders_on_program_kegiatan_id  (program_kegiatan_id)
#  index_genders_on_sasaran_id           (sasaran_id)
#
class Gender < ApplicationRecord
  belongs_to :program_kegiatan, optional: true
  belongs_to :sasaran, optional: true

  serialize :penyebab_internal, Array
  serialize :penyebab_external, Array
  serialize :data_terpilah, Array

  validates :sasaran_id, presence: true
  validates :program_kegiatan_id, presence: true
  validates :reformulasi_tujuan, presence: true
  validates :akses, presence: true
  validates :partisipasi, presence: true
  validates :kontrol, presence: true
  validates :manfaat, presence: true
  validates :penyebab_internal, presence: true
  validates :penyebab_external, presence: true

  before_save :remove_blank_penyebab_internal
  before_save :remove_blank_penyebab_external
  before_save :remove_blank_data_terpilah

  def remove_blank_penyebab_internal
    penyebab_internal.reject!(&:blank?)
  end

  def remove_blank_penyebab_external
    penyebab_external.reject!(&:blank?)
  end

  def remove_blank_data_terpilah
    data_terpilah.reject!(&:blank?)
  end

  def faktor_kesenjangan
    "akses: #{akses},
     partisipasi: #{partisipasi},
     kontrol: #{kontrol},
     manfaat: #{manfaat}.
    "
  end

  def data_pembuka_wawasan
    "tujuan: #{sasaran.sasaran_kinerja}.
    penerima manfaat: #{sasaran.penerima_manfaat}.
    data terpilah: #{sasaran.rincian.data_terpilah}.
    permasalahan: #{sasaran.permasalahan_sasaran}
    "
  end

  def data_baseline
    "tujuan: #{sasaran_subkegiatan}.
    penerima manfaat: #{penerima_manfaat}.
    data terpilah: #{data_terpilah_gender}.
    "
  end

  def data_terpilah_gender
    data_terpilah.is_a?(Array) ? data_terpilah.join(',') : data_terpilah
  end

  def indikator_gender
    "indikator: #{indikator}.
     target: #{target} #{satuan}.
    "
  end

  def penyebab_internal_non_html
    penyebab_internal.is_a?(Array) ? penyebab_internal.join(',') : penyebab_internal
  end

  def penyebab_external_non_html
    penyebab_external.is_a?(Array) ? penyebab_external.join(',') : penyebab_external
  end

  def penyebab_internal_gender
    penyebab_internal.is_a?(Array) ? list_html_style(penyebab_internal) : penyebab_internal
  end

  def penyebab_external_gender
    penyebab_external.is_a?(Array) ? list_html_style(penyebab_external) : penyebab_external
  end

  def list_html_style(list_items)
    self.class.include ActionView::Helpers
    self.class.include ActionView::Context
    content_tag(:ol, class: 'list_items') do
      list_items.each { |item| concat(content_tag(:li, item)) }
    end
  end
end
