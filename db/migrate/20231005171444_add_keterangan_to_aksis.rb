class AddKeteranganToAksis < ActiveRecord::Migration[6.1]
  def change
    add_column :aksis, :keterangan, :string, null: true
  end
end
