class UpdateSearchAllUsulansToVersion3 < ActiveRecord::Migration[6.1]
  def change
  
    update_view :search_all_usulans, version: 3, revert_to_version: 2
  end
end
