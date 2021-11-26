class CreateKesenjangans < ActiveRecord::Migration[6.1]
  def change
    create_table :kesenjangans do |t|
      t.string :akses
      t.string :partisipasi
      t.string :kontrol
      t.string :manfaat

      t.timestamps
    end
  end
end
