class CreateInovasiTims < ActiveRecord::Migration[6.1]
  def change
    create_table :inovasi_tims do |t|
      t.string :nama_inovasi
      t.string :jenis_inovasi
      t.string :nilai_kebaruan
      t.string :tahun
      t.references :crosscutting, null: false, foreign_key: true

      t.timestamps
    end
  end
end
