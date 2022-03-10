class UpdateSearchAllUsulansToVersion2 < ActiveRecord::Migration[6.1]
  def change
    update_view :search_all_usulans, version: 2, revert_to_version: 1
  end
end
