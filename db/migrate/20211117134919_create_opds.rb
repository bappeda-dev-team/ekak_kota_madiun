class CreateOpds < ActiveRecord::Migration[6.1]
  def change
    create_table :opds do |t|
      t.string :nama_opd
      t.string :kode_opd

      t.timestamps
    end
  end
end
