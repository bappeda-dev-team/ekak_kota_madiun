class AddNamaKepalaNipKepalaTahun < ActiveRecord::Migration[6.1]
  def change
    add_column :opds, :nama_kepala, :string, :null => true
    add_column :opds, :nip_kepala, :string, :null => true
    add_column :opds, :status_kepala, :string, :null => true
    add_column :opds, :tahun, :string, :null => true
    add_column :opds, :id_daerah, :string, :null => true
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
