class CreatePokpirs < ActiveRecord::Migration[6.1]
  def change
    create_table :pokpirs do |t|
      t.string :usulan
      t.string :alamat

      t.timestamps
    end
  end
end
