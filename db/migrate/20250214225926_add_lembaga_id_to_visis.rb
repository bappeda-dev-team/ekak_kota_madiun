class AddLembagaIdToVisis < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :visis, :lembaga, null: false, foreign_key: true
  end
end
