# == Schema Information
#
# Table name: perhitungans
#
#  id             :bigint           not null, primary key
#  deskripsi      :string
#  harga          :decimal(, )
#  jenis_anggaran :string
#  satuan         :string
#  spesifikasi    :text
#  tahun          :string
#  total          :decimal(, )
#  volume         :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  anggaran_id    :bigint
#  barang_id      :bigint
#  pajak_id       :bigint
#
# Indexes
#
#  index_perhitungans_on_anggaran_id  (anggaran_id)
#
# Foreign Keys
#
#  fk_rails_...  (pajak_id => pajaks.id) ON DELETE => nullify
#
class Perhitungan < ApplicationRecord
  after_save :update_jumlah_anggaran
  after_update :new_hitung_total
  after_destroy :update_jumlah_anggaran_destroy

  belongs_to :anggaran
  belongs_to :pajak, optional: true
  has_many :koefisiens, inverse_of: :perhitungan
  accepts_nested_attributes_for :koefisiens, allow_destroy: true

  validates :deskripsi, presence: true # uraian
  # validates :satuan, presence: true
  validates :harga, presence: true, numericality: true

  BATAS_KENA_PAJAK = 2_000_000

  def hitung_total
    return if destroyed?

    total_akhir = kalkulasi_harga_total
    update_column(:total, total_akhir)
  end

  def new_hitung_total
    return if destroyed?

    # TODO: TEST THIS PLEASE
    total_akhir = new_kalkulasi_harga_total
    update_column(:total, total_akhir)
  end

  def kalkulasi_harga_total
    if koefisiens.any?
      total_volume = []
      koefisiens.map do |k|
        total_volume << k.volume
      end
      volume = total_volume.reduce(:*)
      total_harga = volume * harga
      pajak_anggaran = anggaran.pajak.potongan
      total_plus_pajak = total_harga * pajak_anggaran
      total_harga + total_plus_pajak
    else
      0
    end
  end

  def new_kalkulasi_harga_total
    if koefisiens.any?
      total_volume = []
      koefisiens.map do |k|
        total_volume << k.volume
      end
      volume = total_volume.reduce(:*)
      total_harga = volume * harga
      potongan = pajak&.potongan || 0
      total_plus_pajak = total_harga * potongan
      total_harga + total_plus_pajak
    else
      0
    end
  end

  def update_pajak_otomatis!
    pajak_update = Pajak.find_by(potongan: 0.11).id
    update_column(:pajak_id, pajak_update) if total >= BATAS_KENA_PAJAK
  end

  def update_jumlah_anggaran
    anggaran.perhitungan_jumlah
  end

  def update_jumlah_anggaran_destroy
    anggaran.perhitungan_jumlah
  end

  def list_koefisien
    koefisiens.map { |m| "#{m.volume} #{m.satuan_volume}" }.join(' x ')
  end

  def harga_plus_pajak
    pajak.potongan * harga_non_pajak
  end

  def plus_pajak
    pajak.potongan * 100
  rescue StandardError
    0
  end

  def sync_total
    run_callbacks :update do
      puts '- save'
    end
  end

  def harga_non_pajak
    if koefisiens.any?
      total_volume = []
      koefisiens.map do |k|
        total_volume << k.volume
      end
      volume = total_volume.reduce(:*)
      volume * harga
    else
      0
    end
  end

  def opd_id
    anggaran.sasaran.opd.id
  end

  def deskripsi_anggaran
    uraians = if tahun.present?
                Search::AllAnggaran.where(tahun: tahun,
                                          harga_satuan: harga.to_i)
              else
                Search::AllAnggaran.where(harga_satuan: harga.to_i)
              end
    uraians = uraians.where("concat_ws(' ', kode_barang, searchable_id) ILIKE ?", "%#{deskripsi}%")
    if uraians.size > 1
      uraians.select { |search| search.searchable.opd_id == opd_id }
    else
      uraians
    end
  end

  def uraian_barang
    deskripsi_anggaran.first.uraian_barang
  rescue NoMethodError
    'Tidak Ditemukan'
  end

  def usulan_opd?
    deskripsi_anggaran.first.searchable.opd_id.present?
  end
end
