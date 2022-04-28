class AddUniqueToIdUnikMusrenbangsPokpirs < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :musrenbangs, :id_unik, unique: true, algorithm: :concurrently
  end
end
