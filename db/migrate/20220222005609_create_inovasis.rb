class CreateInovasis < ActiveRecord::Migration[6.1]
  def change
    create_table :inovasis do |t|
      t.string :usulan
      t.string :manfaat

      t.timestamps
    end
  end
end
