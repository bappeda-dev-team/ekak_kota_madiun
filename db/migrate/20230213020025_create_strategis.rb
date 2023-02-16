class CreateStrategis < ActiveRecord::Migration[6.1]
  def change
    create_table :strategis do |t|
      t.string :strategi
      t.string :tahun
      t.string :sasaran_id
      t.string :strategi_ref_id
      t.string :nip_asn

      t.timestamps
    end
  end
end
