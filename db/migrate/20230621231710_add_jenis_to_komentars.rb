class AddJenisToKomentars < ActiveRecord::Migration[6.1]
  def change
    add_column :komentars, :jenis, :string, null: true
  end
end
