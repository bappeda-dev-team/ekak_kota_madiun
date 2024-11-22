class CreateCrosscuttings < ActiveRecord::Migration[6.1]
  def change
    create_table :crosscuttings do |t|
      t.string :tipe_crosscutting
      t.string :opd_pelaksana, null: true
      t.references :strategi, null: false, foreign_key: true

      t.timestamps
    end
  end
end
