class UpdateSearchAllAnggaransToVersion6 < ActiveRecord::Migration[6.1]
  def change
  
    update_view :search_all_anggarans, version: 6, revert_to_version: 5
  end
end
