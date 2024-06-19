class AddPohonKhususToPohons < ActiveRecord::Migration[6.1]
  def change
    add_column :pohons, :pohon_khusus, :boolean, default: false
  end
end
