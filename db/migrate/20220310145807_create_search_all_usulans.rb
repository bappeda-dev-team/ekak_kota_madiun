class CreateSearchAllUsulans < ActiveRecord::Migration[6.1]
  def change
    create_view :search_all_usulans
  end
end
