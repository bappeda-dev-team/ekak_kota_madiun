class CreateLatarBelakangs < ActiveRecord::Migration[6.1]
  def change
    create_table :latar_belakangs do |t|
      t.text :dasar_hukum
      t.text :gambaran_umum

      t.timestamps
    end
  end
end
