class CreateKebutuhans < ActiveRecord::Migration[6.1]
  def change
    create_table :kebutuhans do |t|
      t.string :kebutuhan
      t.string :tahun
      t.string :keterangan

      t.timestamps
    end
  end
end
