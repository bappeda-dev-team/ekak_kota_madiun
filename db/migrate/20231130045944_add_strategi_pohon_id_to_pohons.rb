class AddStrategiPohonIdToPohons < ActiveRecord::Migration[6.1]
  def change
    add_column :pohons, :strategi_pohon_id, :bigint
  end
end
