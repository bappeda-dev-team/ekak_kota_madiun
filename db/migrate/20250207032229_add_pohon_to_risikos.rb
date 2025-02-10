class AddPohonToRisikos < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :risikos, :pohon, null: false, foreign_key: true
  end
end
