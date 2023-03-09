class UpdateSearchAllAnggaransToVersion4 < ActiveRecord::Migration[6.1]
  def change
    update_view :search_all_anggarans, version: 4, revert_to_version: 3
  end
end
