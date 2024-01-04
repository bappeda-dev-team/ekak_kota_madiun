class CreateDataDukungs < ActiveRecord::Migration[6.1]
  def change
    create_table :data_dukungs do |t|
      t.string :nama_data
      t.string :keterangan

      t.timestamps
    end
  end
end
