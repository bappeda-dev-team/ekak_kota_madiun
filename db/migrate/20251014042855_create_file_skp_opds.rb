class CreateFileSkpOpds < ActiveRecord::Migration[6.1]
  def change
    create_table :file_skp_opds do |t|
      t.string :kode_unik_opd
      t.string :tahun

      t.timestamps
    end
  end
end
