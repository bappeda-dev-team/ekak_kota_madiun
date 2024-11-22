class RemoveTeamRefIdFromTims < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      remove_column :tims, :team_ref_id, :bigint
    end
  end
end
