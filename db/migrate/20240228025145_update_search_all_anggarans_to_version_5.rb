class UpdateSearchAllAnggaransToVersion5 < ActiveRecord::Migration[6.1]
  def change
  
    update_view :search_all_anggarans, version: 5, revert_to_version: 4
  end
end
