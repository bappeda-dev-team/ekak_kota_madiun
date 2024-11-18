class AddStrategiIdToIndikatorsUser < ActiveRecord::Migration[6.1]
  def change
    add_column :indikators_users, :strategi_id, :bigint
  end
end
