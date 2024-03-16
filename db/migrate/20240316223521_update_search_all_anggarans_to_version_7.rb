class UpdateSearchAllAnggaransToVersion7 < ActiveRecord::Migration[6.1]
  def change
  
    update_view :search_all_anggarans, version: 7, revert_to_version: 6
  end
end
