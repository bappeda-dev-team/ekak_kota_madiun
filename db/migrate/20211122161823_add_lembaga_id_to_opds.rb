class AddLembagaIdToOpds < ActiveRecord::Migration[6.1]
  def change
    add_column :opds, :lembaga_id, :int
  end
end
