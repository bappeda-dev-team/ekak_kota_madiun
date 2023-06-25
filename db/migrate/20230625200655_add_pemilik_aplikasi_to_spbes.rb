class AddPemilikAplikasiToSpbes < ActiveRecord::Migration[6.1]
  def change
    add_column :spbes, :pemilik_aplikasi, :string, null: true
  end
end
