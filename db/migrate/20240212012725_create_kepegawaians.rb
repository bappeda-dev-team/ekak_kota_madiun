class CreateKepegawaians < ActiveRecord::Migration[6.1]
  def change
    create_table :kepegawaians do |t|
      t.string :status_kepegawaian
      t.integer :jumlah
      t.references :jabatan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
