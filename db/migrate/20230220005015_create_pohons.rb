class CreatePohons < ActiveRecord::Migration[6.1]
  def change
    create_table :pohons do |t|
      t.string :keterangan
      t.references :pohonable, polymorphic: true
      t.timestamps
    end
  end
end
