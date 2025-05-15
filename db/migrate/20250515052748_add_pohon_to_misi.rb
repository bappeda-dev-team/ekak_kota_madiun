class AddPohonToMisi < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :misis, :pohon, null: true, foreign_key: true
  end
end
