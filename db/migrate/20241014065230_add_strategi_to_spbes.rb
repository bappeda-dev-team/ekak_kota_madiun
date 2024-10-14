class AddStrategiToSpbes < ActiveRecord::Migration[6.1]
  def change
    add_column :spbes, :strategi_id, :bigint, null: true
  end
end
