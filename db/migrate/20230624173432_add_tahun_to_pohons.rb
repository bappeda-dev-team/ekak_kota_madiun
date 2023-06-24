class AddTahunToPohons < ActiveRecord::Migration[6.1]
  def change
    add_column :pohons, :tahun, :string, null: true
  end
end
