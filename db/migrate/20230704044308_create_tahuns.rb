class CreateTahuns < ActiveRecord::Migration[6.1]
  def change
    create_table :tahuns do |t|
      t.string :tahun
      t.bigint :periode_id

      t.timestamps
    end
  end
end
