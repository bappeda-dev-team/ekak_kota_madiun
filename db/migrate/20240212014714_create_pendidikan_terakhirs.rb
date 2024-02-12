class CreatePendidikanTerakhirs < ActiveRecord::Migration[6.1]
  def change
    create_table :pendidikan_terakhirs do |t|
      t.string :pendidikan
      t.string :keterangan
      t.references :kepegawaian, null: false, foreign_key: true

      t.timestamps
    end
  end
end
