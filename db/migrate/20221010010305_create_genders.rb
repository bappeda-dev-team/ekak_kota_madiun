class CreateGenders < ActiveRecord::Migration[6.1]
  def change
    create_table :genders do |t|
      t.string :akses
      t.string :partisipasi
      t.string :kontrol
      t.string :manfaat
      t.references :sasaran
      t.references :program_kegiatan

      t.timestamps
    end
  end
end
