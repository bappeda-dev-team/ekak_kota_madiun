class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :head
      t.text :body, null: false
      t.references :anggaran, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: false

      t.timestamps
    end
  end
end

class AddForeignKeyFromCommentsToUser < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :comments, :user
  end

end
