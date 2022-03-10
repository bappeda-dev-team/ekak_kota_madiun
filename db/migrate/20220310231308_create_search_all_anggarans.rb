class CreateSearchAllAnggarans < ActiveRecord::Migration[6.1]
  def change
    create_view :search_all_anggarans
  end
end
