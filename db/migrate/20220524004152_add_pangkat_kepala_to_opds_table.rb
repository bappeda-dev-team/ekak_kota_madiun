class AddPangkatKepalaToOpdsTable < ActiveRecord::Migration[6.1]
  def change
    add_column :opds, :pangkat_kepala, :string, :null => true, :after => :nama_kepala
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
