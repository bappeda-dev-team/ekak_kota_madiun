class CreateUsulans < ActiveRecord::Migration[6.1]
  def change
    create_table :usulans do |t|
      t.string :keterangan
      t.references :usulanable, polymorphic: true
      t.timestamps
    end
  end
end
