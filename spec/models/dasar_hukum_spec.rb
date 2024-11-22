# == Schema Information
#
# Table name: dasar_hukums
#
#  id         :bigint           not null, primary key
#  judul      :string
#  keterangan :string
#  metadata   :jsonb
#  peraturan  :text
#  tahun      :string
#  urutan     :integer          default(1), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sasaran_id :string
#  usulan_id  :bigint
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id_rencana)
#
require "rails_helper"

RSpec.describe DasarHukum, type: :model do
  context "validation" do
    it "invalid jika tidak ada peraturan yang ditulis" do
      d = DasarHukum.create(
        peraturan: nil,
        judul: "Permen 86",
        tahun: "2017"
      )
      expect(d).to_not be_valid
    end

    it "invalid tanpa judul" do
      d = DasarHukum.create(
        peraturan: "Peraturan Menteri Dalam Negeri Nomor 86 Tahun 2017 tentang Tata Cara Perencanaan, Pengendalian dan Evaluasi ..",
        tahun: "2017",
        judul: nil
      )
      expect(d).to_not be_valid
    end

    it "valid with this attribute" do
      d = DasarHukum.create(
        peraturan: "Peraturan Menteri Dalam Negeri Nomor 86 Tahun 2017 tentang Tata Cara Perencanaan, Pengendalian dan Evaluasi ..",
        tahun: "2017",
        judul: "Terserah"
      )
      expect(d).to be_valid
    end
  end
end
