class CreateSubdomains < ActiveRecord::Migration[6.1]
  def change
    create_table :subdomains do |t|
      t.string :subdomain
      t.references :domain, null: true, foreign_key: true
      t.string :kode_subdomain
      t.string :keterangan
      t.string :tahun

      t.timestamps
    end
  end
end
