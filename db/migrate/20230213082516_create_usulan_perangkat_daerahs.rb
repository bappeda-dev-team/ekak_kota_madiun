class CreateUsulanPerangkatDaerahs < ActiveRecord::Migration[6.1]
  def change
    create_table :usulan_perangkat_daerahs do |t|
      t.integer :perangkat_daerah_id
      t.integer :strategi_kota_id
      t.integer :isu_strategis_kota_id

      t.timestamps
    end
  end
end
