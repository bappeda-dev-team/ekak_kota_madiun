# == Schema Information
#
# Table name: file_skp_opds
#
#  id            :bigint           not null, primary key
#  kode_unik_opd :string
#  tahun         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class FileSkpOpd < ApplicationRecord
  belongs_to :opd, foreign_key: 'kode_unik_opd', primary_key: 'kode_unik_opd'
  has_one_attached :file_skp

  validates :kode_unik_opd, presence: true
  validates :tahun, presence: true

  private

  def file_is_pdf
    return unless file_skp.attached?

    if file.blob.content_type != "application/pdf"
      errors.add(:file_skp, "harus berupa file PDF")
      file.purge # opsional: hapus file yang salah tipe
    end
  end
end
