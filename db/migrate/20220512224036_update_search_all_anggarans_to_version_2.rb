class UpdateSearchAllAnggaransToVersion2 < ActiveRecord::Migration[6.1]
  def change
    replace_view :search_all_anggarans, version: 2, revert_to_version: 1
  end
end
