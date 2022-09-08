class AddKeyActivitiesToLatarBelakangs < ActiveRecord::Migration[6.1]
  def change
    add_column :latar_belakangs, :key_activities, :string, null: true
  end
end
