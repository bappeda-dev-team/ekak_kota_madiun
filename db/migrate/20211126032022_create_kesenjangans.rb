class CreateKesenjangans < ActiveRecord::Migration[6.1]
  def change
    create_table :kesenjangans do |t|
      t.references :rincian, null: false, foreign_key: true
      t.string :akses
      t.string :partisipasi
      t.string :kontrol
      t.string :manfaat

      t.timestamps
    end
  end
end
