class AddDeskripsiToPerhitungans < ActiveRecord::Migration[6.1]
  def change
    add_column :perhitungans, :deskripsi, :string
  end
end
