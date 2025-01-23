class AddIsActiveToPohons < ActiveRecord::Migration[6.1]
  def change
    add_column :pohons, :is_active, :boolean, null: false, default: true
  end
end
