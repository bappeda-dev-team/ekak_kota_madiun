class CreateExternalUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :external_urls do |t|
      t.string :aplikasi
      t.text :endpoint
      t.string :username
      t.string :password
      t.string :keterangan
      t.string :kode

      t.timestamps
    end
    add_index :external_urls, :kode, unique: true
  end
end
