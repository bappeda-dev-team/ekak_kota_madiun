class CreateDomains < ActiveRecord::Migration[6.1]
  def change
    create_table :domains do |t|
      t.string :domain
      t.string :kode_domain
      t.string :keterangan
      t.string :tahun

      t.timestamps
    end
  end
end
